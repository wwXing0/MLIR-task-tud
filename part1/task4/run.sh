#!/usr/bin/env bash
set -euo pipefail

LLVM_BIN="$HOME/mlir-task/llvm-install/bin"
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

# Interchange the Linalg iterators from (i, j, k) to (i, k, j).
"$LLVM_BIN/mlir-opt" ../task2/matmul_generic.mlir \
	--transform-preload-library="transform-library-paths=interchange.mlir" \
	--transform-interpreter \
	-o matmul_interchanged_linalg.mlir

# Generate SCF loops.
"$LLVM_BIN/mlir-opt" matmul_interchanged_linalg.mlir \
	--convert-linalg-to-loops \
	-o matmul_interchanged_scf.mlir

# Generate affine loops.
"$LLVM_BIN/mlir-opt" matmul_interchanged_linalg.mlir \
	--convert-linalg-to-affine-loops \
	-o matmul_interchanged_affine.mlir
