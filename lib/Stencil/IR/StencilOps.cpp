//===- StencilOps.cpp - Stencil operations -------------------------------===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Stencil/IR/StencilOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/IR/OpImplementation.h"
#include "mlir/IR/TypeUtilities.h"
#include "llvm/Support/Casting.h"

using namespace mlir;
using namespace mlir::stencil;

#define GET_OP_CLASSES
#include "Stencil/IR/StencilOps.cpp.inc"

static LogicalResult verifyOffsets(Operation *op, ArrayAttr offsets) {
  if (offsets.empty())
    return op->emitOpError("requires a non-empty offsets list");

  for (Attribute offset : offsets) {
    if (llvm::cast<ArrayAttr>(offset).size() != 2)
      return op->emitOpError("each offset should contain exactly two integers");
  }
  return success();
}

LogicalResult ApplyOp::verify() {
  if (failed(verifyOffsets(getOperation(), getOffsets())))
    return failure();

  // Verify that the input and output operands are different
  Value input = getInput();
  Value output = getOutput();
  if (output == input)
    return emitOpError("input and output operands should be different for an "
                       "out-of-place pass");

  // Verify that the input and output shapes are compatible.
  const Type inputDataType = input.getType();
  const Type outputDataType = output.getType();
  if (failed(verifyCompatibleShape(inputDataType, outputDataType)))
    return emitOpError("input and output types should be compatible");

  return success();
}

LogicalResult SweepOp::verify() {
  return verifyOffsets(getOperation(), getOffsets());
}
