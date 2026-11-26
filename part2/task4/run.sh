#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.."

LLVM_INSTALL="$HOME/mlir-task/llvm-install"
LLVM_BIN="$LLVM_INSTALL/bin"
cmake --fresh -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DMLIR_DIR="$LLVM_INSTALL/lib/cmake/mlir" \
  -DLLVM_DIR="$LLVM_INSTALL/lib/cmake/llvm" \
  -DLLVM_EXTERNAL_LIT="$HOME/mlir-task/llvm-build/bin/llvm-lit"

cmake --build build --target standalone-opt --parallel 2

TASK_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
mkdir -p "$TASK_DIR/build"

# Lower stencil operations before passing the module to upstream mlir-opt.
build/bin/standalone-opt examples/stencil_kernels.mlir \
  --stencil-apply-to-linalg \
  --stencil-sweep-to-scf \
  -o "$TASK_DIR/stencil_kernels_lowered.mlir"

# Lower kernels by upstreaming mlir-opt passes
"$LLVM_BIN/mlir-opt" "$TASK_DIR/stencil_kernels_lowered.mlir" \
  --convert-linalg-to-loops \
  --expand-strided-metadata \
  --lower-affine \
  --convert-scf-to-cf \
  --convert-arith-to-llvm \
  --finalize-memref-to-llvm \
  --convert-cf-to-llvm \
  --llvm-request-c-wrappers \
  --convert-func-to-llvm \
  --reconcile-unrealized-casts \
  -o "$TASK_DIR/stencil_kernels_llvm.mlir"

# Translate the LLVM dialect to LLVM IR
"$LLVM_BIN/mlir-translate" --mlir-to-llvmir \
  "$TASK_DIR/stencil_kernels_llvm.mlir" -o "$TASK_DIR/stencil_kernels.ll"

# Compile the LLVM IR to an object file
"$LLVM_BIN/llc" -O0 -filetype=obj -relocation-model=pic \
  "$TASK_DIR/stencil_kernels.ll" -o "$TASK_DIR/build/stencil_kernels.o"

# Link and run Jacobi-2D
clang -O0 -ffp-contract=off \
  "$TASK_DIR/jacobi_driver.c" "$TASK_DIR/polybench_reference.c" \
  "$TASK_DIR/build/stencil_kernels.o" -o "$TASK_DIR/build/jacobi_run"

"$TASK_DIR/build/jacobi_run"

# Link and run Seidel-2D
clang -O0 -ffp-contract=off \
  "$TASK_DIR/seidel_driver.c" "$TASK_DIR/polybench_reference.c" \
  "$TASK_DIR/build/stencil_kernels.o" -o "$TASK_DIR/build/seidel_run"

"$TASK_DIR/build/seidel_run"
