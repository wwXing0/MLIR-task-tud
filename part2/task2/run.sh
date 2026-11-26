#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.."

LLVM_INSTALL="$HOME/mlir-task/llvm-install"
cmake --fresh -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DMLIR_DIR="$LLVM_INSTALL/lib/cmake/mlir" \
  -DLLVM_DIR="$LLVM_INSTALL/lib/cmake/llvm" \
  -DLLVM_EXTERNAL_LIT="$HOME/mlir-task/llvm-build/bin/llvm-lit"

cmake --build build --target standalone-opt --parallel 2

cmake --build build --target check-standalone-opt --parallel 2

# Lower stencil.apply to linalg.generic
build/bin/standalone-opt examples/stencil_kernels.mlir \
  --stencil-apply-to-linalg\
  -o part2/task2/stencil_kernels_linalg.mlir

printf 'Generated: part2/task2/stencil_kernels_linalg.mlir\n'