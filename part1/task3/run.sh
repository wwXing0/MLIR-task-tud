#!/usr/bin/env bash
set -euo pipefail

LLVM_BIN="$HOME/mlir-task/llvm-install/bin"
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

# Generate SCF loops.
"$LLVM_BIN/mlir-opt" ../task2/matmul_generic.mlir \
	--convert-linalg-to-loops \
	-o matmul_generic_scf.mlir

# Generate affine loops.
"$LLVM_BIN/mlir-opt" ../task2/matmul_generic.mlir \
	--convert-linalg-to-affine-loops \
	-o matmul_generic_affine.mlir
