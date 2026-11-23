#!/usr/bin/env bash
set -euo pipefail

LLVM_BIN="$HOME/mlir-task/llvm-install/bin"
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

# Verify the two handwritten functions.
"$LLVM_BIN/mlir-opt" matmul_named.mlir -o /dev/null
printf 'matmul_named verification exit code: %s\n' "$?"

"$LLVM_BIN/mlir-opt" matmul_generic.mlir -o /dev/null
printf 'matmul_generic verification exit code: %s\n' "$?"

# Apply the upstream pass that converts named Linalg operations to linalg.generic
"$LLVM_BIN/mlir-opt" matmul_named.mlir --linalg-generalize-named-ops -o matmul_named_generalized.mlir
printf 'named-to-generic conversion exit code: %s\n' "$?"

# Q3: verify the manually edited parallel variant.
"$LLVM_BIN/mlir-opt" matmul_generic_changed.mlir -o /dev/null
printf 'parallel variant verification exit code: %s\n' "$?"
