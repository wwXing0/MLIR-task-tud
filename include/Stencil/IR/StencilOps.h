//===- StencilOps.h - Stencil operations ------------------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef STENCIL_STENCILOPS_H
#define STENCIL_STENCILOPS_H

#include "Stencil/IR/StencilDialect.h"
#include "mlir/Bytecode/BytecodeOpInterface.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/OpDefinition.h"

#define GET_OP_CLASSES
#include "Stencil/IR/StencilOps.h.inc"

#endif // STENCIL_STENCILOPS_H
