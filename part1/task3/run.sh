#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
WORK_DIR="$(dirname -- "$PROJECT_DIR")"
LLVM_BIN="$WORK_DIR/llvm-install/bin"

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

# Generate SCF loops.
"$LLVM_BIN/mlir-opt" ../task2/matmul_generic.mlir \
	--convert-linalg-to-loops \
	-o matmul_generic_scf.mlir

# Generate affine loops.
"$LLVM_BIN/mlir-opt" ../task2/matmul_generic.mlir \
	--convert-linalg-to-affine-loops \
	-o matmul_generic_affine.mlir
