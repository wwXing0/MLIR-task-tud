//===- StencilDialect.td - Stencil dialect ------------------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef STENCIL_DIALECT
#define STENCIL_DIALECT

include "mlir/IR/OpBase.td"

def Stencil_Dialect : Dialect {
  let name = "stencil";
  let summary = "A dialect for two-dimensional stencil computations.";
  let cppNamespace = "::mlir::stencil";
}

#endif // STENCIL_DIALECT
