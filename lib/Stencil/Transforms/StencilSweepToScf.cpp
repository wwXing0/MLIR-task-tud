//===- StencilSweepToScf.cpp - Lower stencil.sweep to loops ---------------===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Stencil/IR/StencilOps.h"
#include "Stencil/Transforms/StencilPasses.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/IR/DialectRegistry.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Casting.h"

#include <algorithm>
#include <array>
#include <cstdint>

using namespace mlir;

namespace {

using Offset = std::array<int64_t, 2>;

Value shiftIndex(OpBuilder &builder, Location loc, Value index, int64_t offset) {
  if (offset == 0)
    return index;
  Value delta = arith::ConstantIndexOp::create(builder, loc, offset);
  return arith::AddIOp::create(builder, loc, index, delta);
}

LogicalResult lowerSweep(stencil::SweepOp op) {
  // 1. Read the offsets and calculate the border widths.
  SmallVector<Offset> offsets;
  int64_t top = 0;
  int64_t bottom = 0;
  int64_t left = 0;
  int64_t right = 0;

  for (Attribute attr : op.getOffsets()) {
    auto pair = llvm::cast<ArrayAttr>(attr);
    int64_t rowOffset = llvm::cast<IntegerAttr>(pair[0]).getInt();
    int64_t colOffset = llvm::cast<IntegerAttr>(pair[1]).getInt();
    offsets.push_back(Offset{rowOffset, colOffset});

    if (rowOffset < 0)
      top = std::max(top, -rowOffset);
    else
      bottom = std::max(bottom, rowOffset);

    if (colOffset < 0)
      left = std::max(left, -colOffset);
    else
      right = std::max(right, colOffset);
  }

  // 2. Calculate the total border width in each dimension.
  Offset required{top + bottom, left + right};

  // 3. Skip the operation if a known dimension has no interior.
  auto inputType = llvm::cast<MemRefType>(op.getInput().getType());
  for (unsigned d = 0; d < 2; ++d) {
    if (!inputType.isDynamicDim(d) && inputType.getDimSize(d) <= required[d]) {
      op.erase();
      return success();
    }
  }

  // 4. Prepare the grid dimensions, loop bounds, step and divisor
  OpBuilder builder(op.getOperation());
  Location loc = op.getLoc();

  Value rows = memref::DimOp::create(builder, loc, op.getInput(), 0);
  Value cols = memref::DimOp::create(builder, loc, op.getInput(), 1);

  Value rowStart = arith::ConstantIndexOp::create(builder, loc, top);
  Value colStart = arith::ConstantIndexOp::create(builder, loc, left);
  Value rowBorder = arith::ConstantIndexOp::create(builder, loc, bottom);
  Value colBorder = arith::ConstantIndexOp::create(builder, loc, right);
  Value rowEnd = arith::SubIOp::create(builder, loc, rows, rowBorder);
  Value colEnd = arith::SubIOp::create(builder, loc, cols, colBorder);
  Value step = arith::ConstantIndexOp::create(builder, loc, 1);
  Value divisor = arith::ConstantOp::create(builder, loc, op.getDivisorAttr());

  // 5. Create sequential loops: rows outside, columns inside
  auto rowLoop = scf::ForOp::create(builder, loc, rowStart, rowEnd, step);
  OpBuilder rowBody = OpBuilder::atBlockBegin(rowLoop.getBody());

  auto colLoop = scf::ForOp::create(rowBody, loc, colStart, colEnd, step);
  OpBuilder point = OpBuilder::atBlockBegin(colLoop.getBody());

  // 6. Get the coordinates of the current point
  Value i = rowLoop.getInductionVar();
  Value j = colLoop.getInductionVar();

  // 7. Load neighbours and sum their values in the listed order
  Value sum;
  for (const Offset &offset : offsets) {
    Value row = shiftIndex(point, loc, i, offset[0]);
    Value col = shiftIndex(point, loc, j, offset[1]);
    Value value = memref::LoadOp::create(point, loc, op.getInput(), ValueRange{row, col});
    if (!sum)
      sum = value;
    else
      sum = arith::AddFOp::create(point, loc, sum, value);
  }

  // 8. Divide the sum and store the result back to the current point.
  Value result = arith::DivFOp::create(point, loc, sum, divisor);
  memref::StoreOp::create(point, loc, result, op.getInput(), ValueRange{i, j});

  // 9. Remove the original stencil.sweep operation.
  op.erase();
  return success();
}

struct StencilSweepToScfPass
    : public PassWrapper<StencilSweepToScfPass, OperationPass<ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(StencilSweepToScfPass)

  StringRef getArgument() const override { return "stencil-sweep-to-scf"; }

  StringRef getDescription() const override {
    return "Lower stencil.sweep to sequential SCF loops";
  }

  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<arith::ArithDialect, memref::MemRefDialect, scf::SCFDialect>();
  }

  void runOnOperation() override {
    SmallVector<stencil::SweepOp> sweeps;
    getOperation().walk([&](stencil::SweepOp op) { sweeps.push_back(op); });
    for (auto op : sweeps) {
      if (failed(lowerSweep(op))) {
        signalPassFailure();
        return;
      }
    }
  }
};

} // namespace

std::unique_ptr<Pass> mlir::stencil::createStencilSweepToScfPass() {
  return std::make_unique<StencilSweepToScfPass>();
}
