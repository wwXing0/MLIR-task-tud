#!/usr/bin/env bash
set -euo pipefail

# Usage: bash scripts/part1/build_starter.sh /path/to/llvm-install

WORK_DIR="$HOME/mlir-task"
PROJECT_DIR="$WORK_DIR/MLIR-task-tud"
LLVM_INSTALL="${1:-$WORK_DIR/llvm-install}"

mkdir -p "$WORK_DIR"
if [[ ! -d "$PROJECT_DIR" ]]; then
	git clone https://github.com/h4midf/MLIR-task-tud.git "$PROJECT_DIR"
fi

cmake -S "$PROJECT_DIR" -B "$PROJECT_DIR/build" -G Ninja \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_COMPILER=/usr/bin/clang \
	-DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
	-DMLIR_DIR="$LLVM_INSTALL/lib/cmake/mlir" \
	-DLLVM_DIR="$LLVM_INSTALL/lib/cmake/llvm" \
	-DLLVM_EXTERNAL_LIT="$WORK_DIR/llvm-build/bin/llvm-lit"

cmake --build "$PROJECT_DIR/build" --target check-standalone-opt --parallel 2

"$PROJECT_DIR/build/bin/standalone-opt" --show-dialects
