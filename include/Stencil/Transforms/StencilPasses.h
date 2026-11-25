//===- StencilPasses.h - Stencil passes ------------------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef STENCIL_STENCILPASSES_H
#define STENCIL_STENCILPASSES_H

#include "mlir/Pass/Pass.h"

#include <memory>

namespace mlir::stencil {

std::unique_ptr<Pass> createStencilApplyToLinalgPass();
void registerStencilPasses();

} // namespace mlir::stencil

#endif // STENCIL_STENCILPASSES_H