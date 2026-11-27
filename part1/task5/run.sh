#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
WORK_DIR="$(dirname -- "$PROJECT_DIR")"
LLVM_BIN="$WORK_DIR/llvm-install/bin"

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

mkdir -p build

# Give the two kernels different names before generating their C wrappers.
sed 's/@matmul_generic(/@matmul_original(/g' \
	../task3/matmul_generic_scf.mlir >build/matmul_original_scf.mlir

sed 's/@matmul_generic(/@matmul_interchanged(/g' \
	../task4/matmul_interchanged_scf.mlir >build/matmul_interchanged_scf.mlir

# Lower the original SCF kernel to the LLVM dialect.
"$LLVM_BIN/mlir-opt" build/matmul_original_scf.mlir \
	--convert-scf-to-cf \
	--convert-arith-to-llvm \
	--finalize-memref-to-llvm \
	--convert-cf-to-llvm \
	--llvm-request-c-wrappers \
	--convert-func-to-llvm \
	--reconcile-unrealized-casts \
	-o matmul_original_llvm.mlir

# Lower the interchanged SCF kernel to the LLVM dialect.
"$LLVM_BIN/mlir-opt" build/matmul_interchanged_scf.mlir \
	--convert-scf-to-cf \
	--convert-arith-to-llvm \
	--finalize-memref-to-llvm \
	--convert-cf-to-llvm \
	--llvm-request-c-wrappers \
	--convert-func-to-llvm \
	--reconcile-unrealized-casts \
	-o matmul_interchanged_llvm.mlir

# Translate the LLVM dialect to LLVM IR.
"$LLVM_BIN/mlir-translate" --mlir-to-llvmir matmul_original_llvm.mlir \
	-o matmul_original.ll

"$LLVM_BIN/mlir-translate" --mlir-to-llvmir matmul_interchanged_llvm.mlir \
	-o matmul_interchanged.ll

# Compile the LLVM IR to object files.
"$LLVM_BIN/llc" -O0 -filetype=obj -relocation-model=pic matmul_original.ll \
	-o build/matmul_original.o

"$LLVM_BIN/llc" -O0 -filetype=obj -relocation-model=pic matmul_interchanged.ll \
	-o build/matmul_interchanged.o

# Link both kernels with one C driver
clang -O0 -ffp-contract=off matmul_driver.c build/matmul_original.o \
	build/matmul_interchanged.o -o build/matmul_run

# run the driver to verify that both kernels produce the same result
./build/matmul_run
