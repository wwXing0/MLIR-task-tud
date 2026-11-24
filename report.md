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

_Left: converted `@matmul_named`; right: handwritten `@matmul_generic`._

The differences are in naming: `#map/#map1/#map2` instead of `#mapA/#mapB/#mapC`, `d0/d1/d2` instead of `i/j/k`, and different SSA names. The function stays named `@matmul_named` because the pass converts the operation without renaming the function. `return` is shorthand for `func.return`.

#### Q1.

At iteration `(d0, d1, d2)`:

| Operand | Indexing map               | Element accessed |
| ------- | -------------------------- | ---------------- |
| A       | `(d0, d1, d2) -> (d0, d2)` | `A[d0, d2]`      |
| B       | `(d0, d1, d2) -> (d2, d1)` | `B[d2, d1]`      |
| C       | `(d0, d1, d2) -> (d0, d1)` | `C[d0, d1]`      |

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

### Task 3: Lower to loops

The lowering commands are in [part1/task3/run.sh](part1/task3/run.sh).

| Version | Generated IR                                                         | IR with comments                                                           |
| ------- | -------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| SCF     | [matmul_generic_scf.mlir](part1/task3/matmul_generic_scf.mlir)       | [SCF IR with comments](part1/task3/matmul_generic_scf_comments.mlir)       |
| Affine  | [matmul_generic_affine.mlir](part1/task3/matmul_generic_affine.mlir) | [Affine IR with comments](part1/task3/matmul_generic_affine_comments.mlir) |

The comments identify the i, j, and k loops, the loads from A, B, and C, and the store to C. These copies are saved separately so rerunning the script does not overwrite the comments.

#### Q4.

I used `--convert-linalg-to-loops` to generate `scf.for` loops and `--convert-linalg-to-affine-loops` to generate `affine.for` loops.

I searched `mlir-opt --help` with `grep "loops"` and checked their descriptions in the official documentation to select these passes: [convert-linalg-to-loops](https://mlir.llvm.org/docs/Passes/#-convert-linalg-to-loops) and [convert-linalg-to-affine-loops](https://mlir.llvm.org/docs/Passes/#-convert-linalg-to-affine-loops).

### Task 4: Loop interchange

The interchange is defined in [interchange.mlir](part1/task4/interchange.mlir). The commands for applying the interchange and lowering the result to loops are in [run.sh](part1/task4/run.sh).

| Version | Generated IR                                                                   | IR with comments                                                                |
| ------- | ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------- |
| SCF     | [matmul_interchanged_scf.mlir](part1/task4/matmul_interchanged_scf.mlir)       | [SCF IR with comments](part1/task4/matmul_interchanged_scf_comments.mlir)       |
| Affine  | [matmul_interchanged_affine.mlir](part1/task4/matmul_interchanged_affine.mlir) | [Affine IR with comments](part1/task4/matmul_interchanged_affine_comments.mlir) |

The comments identify the i, j, and k loops to show the new loop order. The files with comments are saved separately so rerunning the script does not overwrite them.

#### Q5.

The original loop order is `i → j → k`. I chose `i → k → j` by interchanging the `j` and `k` loops.

With row-major storage, the accesses in the innermost loop are:

| Access    | Original order: `i → j → k` (`k` innermost)           | Chosen order: `i → k → j` (`j` innermost) |
| --------- | ----------------------------------------------------- | ----------------------------------------- |
| `A[i, k]` | Consecutive elements along a row                      | Same element                              |
| `B[k, j]` | Elements down a column, with a stride of `N` elements | Consecutive elements along a row          |
| `C[i, j]` | Same element                                          | Consecutive elements along a row          |

In the chosen order `i → k → j` (`j` innermost), every innermost access is either contiguous or unchanged across iterations. This removes the large-stride access to B and improves the spatial locality of accesses to B, which may improve cache efficiency.

#### Q6.

- **How did you apply the interchange?** I applied the interchange at the Linalg level, before lowering to SCF or Affine loops:
  1. In [interchange.mlir](part1/task4/interchange.mlir), `transform.structured.match` selects `linalg.generic`.

  2. `transform.structured.interchange` applies `iterator_interchange = [0, 2, 1]`. This changes the iteration order from `i → j → k` to `i → k → j`, updating the indexing maps and iterator types accordingly.

  3. In [run.sh](part1/task4/run.sh), `--transform-preload-library` loads the script and `--transform-interpreter` executes it. The result is saved as [matmul_interchanged_linalg.mlir](part1/task4/matmul_interchanged_linalg.mlir).

  4. The interchanged Linalg IR is lowered separately to [SCF loops](part1/task4/matmul_interchanged_scf.mlir) using `--convert-linalg-to-loops` and [Affine loops](part1/task4/matmul_interchanged_affine.mlir) using `--convert-linalg-to-affine-loops`.

- **Does the same approach work directly on `@matmul_named`? Why or why not?**

  No, our script matches `linalg.generic`, while `@matmul_named` contains `linalg.matmul`.

  The [official documentation](https://mlir.llvm.org/docs/Dialects/Transform/#transformstructuredinterchange-transforminterchangeop:~:text=This%20operation%20ignores%20non%2Dlinalg%3A%3AGeneric%20ops%20and%20drops%20them%20in%20the%20return.) indicates that `transform.structured.interchange` requires a `linalg.generic` target.

  This is also reflected in the [source definition of InterchangeOp](https://github.com/llvm/llvm-project/blob/4330469cc1694be36cf20cfca9f6dae408e9fbc3/mlir/include/mlir/Dialect/Linalg/TransformOps/LinalgTransformOps.td#L730), where `extraClassDeclaration` declares `applyToOne` with a `linalg::GenericOp target` parameter.

  We can first use `--linalg-generalize-named-ops` to convert `linalg.matmul` to `linalg.generic`, then apply the same interchange script.

#### Q7.

- **Why is moving the reduction loop legal here?**

  Assuming C does not overlap A or B, the inputs are read-only and different output elements can be updated independently.

  The accumulation introduces a loop-carried RAW dependence between successive `k` iterations updating the same `C[i, j]`. After changing the loop order from `i → j → k` to `i → k → j`, `k` remains sequential and this dependence is preserved.

  For adjacent `k` iterations, the dependence distance vector changes from `(0, 0, 1)` to `(0, 1, 0)`, whose first non-zero component is still positive. Therefore, the interchange does not reverse the dependence.

- **Does your interchange preserve the accumulation order for each element of C?**

  Yes. For any fixed `i` and `j`, the products `A[i, k] * B[k, j]` are still added to the initial value of `C[i, j]` in increasing order of `k`, from `0` to `K - 1`. Updates to different output elements are interleaved differently, but the sequence of partial sums for each element is unchanged. Therefore, this interchange does not regroup the floating-point additions.
