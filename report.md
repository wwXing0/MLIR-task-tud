# MLIR Assignment Report

## Part 1: Matrix Multiplication in MLIR

### Task 1: Build LLVM/MLIR and the starter project

The build steps are in [build_llvm.sh](part1/task1/build_llvm.sh) and [build_starter.sh](part1/task1/build_starter.sh):

```bash
bash "$WORK_DIR/MLIR-task-tud/part1/task1/build_llvm.sh"
bash "$WORK_DIR/MLIR-task-tud/part1/task1/build_starter.sh" "$WORK_DIR/llvm-install"
```

I used `llvmorg-23.1.3` and enabled MLIR with `LLVM_ENABLE_PROJECTS=mlir`. `LLVM_ENABLE_ASSERTIONS=ON` keeps internal checks enabled, and `LLVM_INSTALL_UTILS=ON` installs `FileCheck` for the starter tests. The source, build, and installation directories are `$WORK_DIR/llvm-project`, `$WORK_DIR/llvm-build`, and `$WORK_DIR/llvm-install`.

The starter script sets `MLIR_DIR` and `LLVM_DIR` to this installation and builds the `check-standalone-opt` target to build the tool and run its tests.

### Task 2: Express matrix multiplication in Linalg

The handwritten implementations are [matmul_named.mlir](part1/task2/matmul_named.mlir) and [matmul_generic.mlir](part1/task2/matmul_generic.mlir). I verified both files with `mlir-opt` ([run.sh, lines 8–12](part1/task2/run.sh#L8-L12)).

#### Comparison of the converted and handwritten versions

I used the upstream `linalg-generalize-named-ops` pass (`--linalg-generalize-named-ops`) to convert `linalg.matmul` to `linalg.generic`. The command is in [run.sh, lines 15–16](part1/task2/run.sh#L15-L16).

The converted `@matmul_named` and handwritten `@matmul_generic` have the same indexing maps, iterator types, and multiply-add body. Both compute `C += A * B`.

<img src="part1/task2/matmul_comparison.png" alt="Comparison of the converted and handwritten matrix multiplication IR" width="800">

*Left: converted `@matmul_named`; right: handwritten `@matmul_generic`.*

The differences are in naming: `#map/#map1/#map2` instead of `#mapA/#mapB/#mapC`, `d0/d1/d2` instead of `i/j/k`, and different SSA names. The function stays named `@matmul_named` because the pass converts the operation without renaming the function. `return` is shorthand for `func.return`.

#### Q1.

At iteration `(d0, d1, d2)`:

| Operand | Indexing map | Element accessed |
| --- | --- | --- |
| A | `(d0, d1, d2) -> (d0, d2)` | `A[d0, d2]` |
| B | `(d0, d1, d2) -> (d2, d1)` | `B[d2, d1]` |
| C | `(d0, d1, d2) -> (d0, d1)` | `C[d0, d1]` |

The iterator types are `["parallel", "parallel", "reduction"]` for `d0`, `d1`, and `d2`, respectively.

#### Q2.

- **Why is C an outs operand?** C is updated during the computation: its existing value is read for accumulation, and the updated result is written back to it.

- **What value does its block argument hold?** The block argument corresponding to C is `%c`:

    ```mlir
    ^bb0(%a: f64, %b: f64, %c: f64):
      %prod = arith.mulf %a, %b : f64
      %sum = arith.addf %c, %prod : f64
      linalg.yield %sum : f64
    ```

    The `outs` operand provides the current `f64` value of `C[d0, d1]` as `%c`. The body computes `%c + %prod`, and `linalg.yield %sum` supplies the updated value to be written back to C. The first reduction iteration uses C's initial value; later iterations use the value updated by the previous reduction iteration.

- **Does linalg.matmul initialize C to zero?** No. It computes `C += A * B` using the existing values of C.

#### Q3.

- **Which iterator is a reduction, and why?** `d2` (the k dimension) is the reduction iterator. For fixed `d0` and `d1`, each iteration computes `A[d0, d2] * B[d2, d1]` and adds this product to `C[d0, d1]`. As `d2` varies, these products are combined into the same accumulated result.

- **Does verification succeed after changing it to parallel?** Yes. I changed the third iterator to `parallel` in [matmul_generic_changed.mlir](part1/task2/matmul_generic_changed.mlir), so the iterator types are `["parallel", "parallel", "parallel"]`. The modified file is accepted by `mlir-opt`. This check is also included in [run.sh, lines 19–20](part1/task2/run.sh#L19-L20).

- **Is the annotation correct?** No. A later `d2` iteration reads the accumulator value written by the preceding iteration for the same `C[d0, d1]`, creating a loop-carried RAW dependence. These iterations are therefore not independent, so the `parallel` annotation is incorrect. The Linalg documentation requires iterator types to agree with the computation inside the region; violating parallel iterator requirements is undefined behavior.
