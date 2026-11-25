//===- StencilApplyToLinalg.cpp - Lower stencil.apply to Linalg--------------===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Stencil/IR/StencilOps.h"
#include "Stencil/Transforms/StencilPasses.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/IR/DialectRegistry.h"
#include "mlir/Pass/PassRegistry.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Casting.h"

#include <algorithm>
#include <array>
#include <cstdint>

using namespace mlir;

namespace {

using Offset = std::array<int64_t, 2>;

LogicalResult lowerApply(stencil::ApplyOp op) {
  Value inputBuffer = op.getInput();
  Value outputBuffer = op.getOutput();

  auto inputType = llvm::cast<MemRefType>(inputBuffer.getType());
  auto outputType = llvm::cast<MemRefType>(outputBuffer.getType());

  // 1. Read the neighbour offsets and calculate the border widths.
  SmallVector<Offset> neighbourOffsets;

  int64_t top=0, bottom = 0, left = 0, right = 0;

  for (Attribute attr : op.getOffsets()) {
    auto pair = llvm::cast<ArrayAttr>(attr);
    int64_t rowOffset = llvm::cast<IntegerAttr>(pair[0]).getInt();
    int64_t colOffset = llvm::cast<IntegerAttr>(pair[1]).getInt();

    neighbourOffsets.push_back(Offset{rowOffset, colOffset});

    top = std::max(top, -rowOffset);
    bottom = std::max(bottom, rowOffset);
    left = std::max(left, -colOffset);
    right = std::max(right, colOffset);
  }

  // 2. Calculate how many rows and columns the borders occupy.
  int64_t totalBorderRows = top + bottom;
  int64_t totalBorderCols = left + right;

  // If a known dimension has no interior, no computation is needed.
  bool inputIsEmpty = (!inputType.isDynamicDim(0) &&
                       inputType.getDimSize(0) <= totalBorderRows) ||
                      (!inputType.isDynamicDim(1) &&
                       inputType.getDimSize(1) <= totalBorderCols);
  if (inputIsEmpty) {
    op.erase();
    return success();
  }

  if (!inputType.isStrided() || !outputType.isStrided())
    return op.emitOpError("lowering requires strided input and output layouts");

  // 3. Prepare values for the matrix dimensions and border sizes.
  OpBuilder builder(op.getOperation());
  Location loc = op.getLoc();

  Value rows = memref::DimOp::create(builder, loc, inputBuffer, 0);
  Value cols = memref::DimOp::create(builder, loc, inputBuffer, 1);

  Value borderRows =
      arith::ConstantIndexOp::create(builder, loc, totalBorderRows);
  Value borderCols =
      arith::ConstantIndexOp::create(builder, loc, totalBorderCols);

  // 4. Generate: if (rows > borderRows && cols > borderCols).
  Value hasRows = arith::CmpIOp::create(builder, loc, arith::CmpIPredicate::sgt,
                                        rows, borderRows);
  Value hasCols = arith::CmpIOp::create(builder, loc, arith::CmpIPredicate::sgt,
                                        cols, borderCols);
  Value hasInterior = arith::AndIOp::create(builder, loc, hasRows, hasCols);
  auto guard =
      scf::IfOp::create(builder, loc, hasInterior, /*withElseRegion=*/false);
  OpBuilder ifBuilder = OpBuilder::atBlockBegin(&guard.getThenRegion().front());

  // 5. Calculate the interior size inside the if.
  Value interiorRows = arith::SubIOp::create(ifBuilder, loc, rows, borderRows);
  Value interiorCols = arith::SubIOp::create(ifBuilder, loc, cols, borderCols);

  SmallVector<OpFoldResult> viewSizes{interiorRows, interiorCols};
  SmallVector<OpFoldResult> viewSteps{ifBuilder.getIndexAttr(1),
                                      ifBuilder.getIndexAttr(1)};

  // 6. Create one input view for each neighbour.
  //    View start = interior start + neighbour offset.
  SmallVector<Value> inputViews;

  for (const Offset &offset : neighbourOffsets) {
    SmallVector<OpFoldResult> viewStart{
        ifBuilder.getIndexAttr(top + offset[0]),
        ifBuilder.getIndexAttr(left + offset[1])};
    Value view = memref::SubViewOp::create(ifBuilder, loc, inputBuffer,
                                           viewStart, viewSizes, viewSteps);
    inputViews.push_back(view);
  }

  // 7. Create the output view covering only the interior.
  SmallVector<OpFoldResult> outputStart{ifBuilder.getIndexAttr(top),
                                        ifBuilder.getIndexAttr(left)};

  Value outputView = memref::SubViewOp::create(
      ifBuilder, loc, outputBuffer, outputStart, viewSizes, viewSteps);

  // 8. Prepare the scale, identity maps and parallel iterators.
  Value scale = arith::ConstantOp::create(ifBuilder, loc, op.getScaleAttr());
  SmallVector<AffineMap> indexingMaps(inputViews.size() + 1,
                                      ifBuilder.getMultiDimIdentityMap(2));
  SmallVector<utils::IteratorType> iteratorTypes{utils::IteratorType::parallel,
                                                 utils::IteratorType::parallel};

  // 9. Generate the computation for each point.
  linalg::GenericOp::create(
      ifBuilder, loc, TypeRange{},
      /*inputs=*/inputViews, /*outputs=*/ValueRange{outputView},
      /*indexingMaps=*/indexingMaps, /*iteratorTypes=*/iteratorTypes,
      [&](OpBuilder &bodyBuilder, Location bodyLoc, ValueRange blockArgs) {
        Value temp = blockArgs[0];

        for (unsigned i = 1; i < inputViews.size(); ++i) {
          temp =
              arith::AddFOp::create(bodyBuilder, bodyLoc, temp, blockArgs[i]);
        }
        Value result = arith::MulFOp::create(bodyBuilder, bodyLoc, temp, scale);
        linalg::YieldOp::create(bodyBuilder, bodyLoc, result);
      });

  // 10. Erase the original operation.
  op.erase();
  return success();
}

struct StencilApplyToLinalgPass
    : public PassWrapper<StencilApplyToLinalgPass, OperationPass<ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(StencilApplyToLinalgPass)

  StringRef getArgument() const override { return "stencil-apply-to-linalg"; }

  StringRef getDescription() const override {
    return "Lower stencil.apply to shifted views and Linalg";
  }

  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<arith::ArithDialect, linalg::LinalgDialect,
                    memref::MemRefDialect, scf::SCFDialect>();
  }

  void runOnOperation() override {
    SmallVector<stencil::ApplyOp> applies;
    getOperation().walk([&](stencil::ApplyOp op) { applies.push_back(op); });
    for (auto op : applies) {
      if (failed(lowerApply(op))) {
        signalPassFailure();
        return;
      }
    }
  }
};

} // namespace

std::unique_ptr<Pass> mlir::stencil::createStencilApplyToLinalgPass() {
  return std::make_unique<StencilApplyToLinalgPass>();
}

void mlir::stencil::registerStencilPasses() {
  PassRegistration<StencilApplyToLinalgPass>();
}
