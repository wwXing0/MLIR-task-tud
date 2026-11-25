//===- StencilDialect.cpp - Stencil dialect-------------------------------===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Stencil/IR/StencilDialect.h"
#include "Stencil/IR/StencilOps.h"

using namespace mlir;
using namespace mlir::stencil;

#include "Stencil/IR/StencilDialect.cpp.inc"

void StencilDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "Stencil/IR/StencilOps.cpp.inc"
      >();
}
