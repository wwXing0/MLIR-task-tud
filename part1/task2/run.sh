#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
WORK_DIR="$(dirname -- "$PROJECT_DIR")"
LLVM_BIN="$WORK_DIR/llvm-install/bin"

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

# Verify the two handwritten functions.
"$LLVM_BIN/mlir-opt" matmul_named.mlir
"$LLVM_BIN/mlir-opt" matmul_generic.mlir

# Convert named Linalg operations to linalg.generic.
"$LLVM_BIN/mlir-opt" matmul_named.mlir \
  --linalg-generalize-named-ops \
  -o matmul_named_generalized.mlir

# Q3: verify the manually edited parallel variant.
"$LLVM_BIN/mlir-opt" matmul_generic_changed.mlir
