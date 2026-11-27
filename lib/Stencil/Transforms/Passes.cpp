//===- Passes.cpp - Register Stencil passes -------------------------------===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Stencil/Transforms/StencilPasses.h"
#include "mlir/Pass/PassRegistry.h"

void mlir::stencil::registerStencilPasses() {
  registerPass(createStencilApplyToLinalgPass);
  registerPass(createStencilSweepToScfPass);
}
