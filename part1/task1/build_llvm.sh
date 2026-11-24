#!/usr/bin/env bash
set -euo pipefail

WORK_DIR="$HOME/mlir-task"
LLVM_INSTALL="$WORK_DIR/llvm-install"

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

if [[ ! -d llvm-project ]]; then
	git clone --depth 1 --branch llvmorg-23.1.3 \
		https://github.com/llvm/llvm-project.git llvm-project
fi

cmake -S llvm-project/llvm -B llvm-build -G Ninja \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_COMPILER=/usr/bin/clang \
	-DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
	-DCMAKE_INSTALL_PREFIX="$LLVM_INSTALL" \
	-DLLVM_ENABLE_PROJECTS=mlir \
	-DLLVM_TARGETS_TO_BUILD=X86 \
	-DLLVM_ENABLE_ASSERTIONS=ON \
	-DLLVM_ENABLE_RTTI=OFF \
	-DLLVM_BUILD_EXAMPLES=OFF \
	-DLLVM_INSTALL_UTILS=ON \
	-DLLVM_PARALLEL_LINK_JOBS=1

cmake --build llvm-build --parallel 8
cmake --install llvm-build

printf 'LLVM installation: %s\n' "$LLVM_INSTALL"
