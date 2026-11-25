//===- StencilOps.td - Stencil operations -------------------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef STENCIL_OPS
#define STENCIL_OPS

include "mlir/IR/OpBase.td"
include "Stencil/IR/StencilDialect.td"

class Stencil_Op<string mnemonic, list<Trait> traits = []> :
    Op<Stencil_Dialect, mnemonic, traits>;

def Stencil_ApplyOp : Stencil_Op<"apply"> {
  let summary = "Compute one out-of-place stencil pass";
  let description = [{
    Read neighbours from the input using the listed offsets. Sum their
    values in the listed order, then multiply by scale and write the result
    to the output interior. 

    Example:

    stencil.apply ins(%A : memref<?x?xf64>) outs(%B : memref<?x?xf64>)
                  offsets [[0, 0], [0, -1], [0, 1], [1, 0], [-1, 0]] scale(0.2)

  }];

  let arguments = (ins
    MemRefRankOf<[F64], [2]>:$input,
    MemRefRankOf<[F64], [2]>:$output,
    IndexListArrayAttr:$offsets,
    F64Attr:$scale
  );
  let results = (outs);
  let hasVerifier = 1;

  let assemblyFormat = [{
    `ins` `(` $input `:` type($input) `)`
    `outs` `(` $output `:` type($output) `)`
    `offsets` $offsets
    `scale` `(` $scale `)` attr-dict
  }];
}

def Stencil_SweepOp : Stencil_Op<"sweep"> {
  let summary = "Compute one ordered in-place stencil pass";
  let description = [{
    Update the input interior in lexicographic order, with the first
    dimension outermost. Read neighbours using the listed offsets, sum
    their values in the listed order, then divide by divisor and store
    the result back into the input.
    
    Example:
    
    stencil.sweep %A offsets [[-1, -1], [-1, 0], [-1, 1],
                              [ 0, -1], [ 0, 0], [ 0, 1],
                              [ 1, -1], [ 1, 0], [ 1, 1]]
                     divisor(9.0) : memref<?x?xf64>
  }];

  let arguments = (ins
    MemRefRankOf<[F64], [2]>:$input,
    IndexListArrayAttr:$offsets,
    F64Attr:$divisor
  );
  let results = (outs);
  let hasVerifier = 1;

  let assemblyFormat = [{
    $input `offsets` $offsets
    `divisor` `(` $divisor `)` attr-dict `:` type($input)
  }];
}

#endif // STENCIL_OPS
