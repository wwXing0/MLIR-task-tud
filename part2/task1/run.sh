#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.."

LLVM_INSTALL="$HOME/mlir-task/llvm-install"
cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DMLIR_DIR="$LLVM_INSTALL/lib/cmake/mlir" \
  -DLLVM_DIR="$LLVM_INSTALL/lib/cmake/llvm" \
  -DLLVM_EXTERNAL_LIT="$HOME/mlir-task/llvm-build/bin/llvm-lit"

# Build the tool and run tests.
cmake --build build --target check-standalone-opt --parallel 2

# Parse and print the two stencil kernels.
build/bin/standalone-opt examples/stencil_kernels.mlir
