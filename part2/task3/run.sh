#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
WORK_DIR="$(dirname -- "$PROJECT_DIR")"
LLVM_INSTALL="$WORK_DIR/llvm-install"

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.."

cmake --fresh -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DMLIR_DIR="$LLVM_INSTALL/lib/cmake/mlir" \
  -DLLVM_DIR="$LLVM_INSTALL/lib/cmake/llvm" \
  -DLLVM_EXTERNAL_LIT="$WORK_DIR/llvm-build/bin/llvm-lit"

cmake --build build --target check-standalone-opt --parallel 2

# Lower stencil.sweep to sequential SCF loops
build/bin/standalone-opt examples/stencil_kernels.mlir \
  --stencil-sweep-to-scf \
  -o part2/task3/stencil_kernels_scf.mlir

printf 'Generated: part2/task3/stencil_kernels_scf.mlir\n'