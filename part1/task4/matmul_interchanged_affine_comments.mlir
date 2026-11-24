module {
  // Loop order after interchange: i -> k -> j.
  // %arg0 = A, %arg1 = B, %arg2 = C.
  // %arg3 = i, %arg4 = k, %arg5 = j.
  func.func @matmul_generic(%arg0: memref<?x?xf64>, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    // M: number of rows of A.
    %dim = memref.dim %arg0, %c0 : memref<?x?xf64>
    // K: number of columns of A.
    %dim_0 = memref.dim %arg0, %c1 : memref<?x?xf64>
    // N: number of columns of B.
    %dim_1 = memref.dim %arg1, %c1 : memref<?x?xf64>
    // i loop: rows of C.
    affine.for %arg3 = 0 to %dim {
      // k loop: reduction dimension, now at the middle.
      affine.for %arg4 = 0 to %dim_0 {
        // j loop: columns of C, now the innermost loop.
        affine.for %arg5 = 0 to %dim_1 {
          // Load A[i, k]
          %0 = affine.load %arg0[%arg3, %arg4] : memref<?x?xf64>
          // Load B[k, j]
          %1 = affine.load %arg1[%arg4, %arg5] : memref<?x?xf64>
          // Load the current C[i, j]
          %2 = affine.load %arg2[%arg3, %arg5] : memref<?x?xf64>
          %3 = arith.mulf %0, %1 : f64
          %4 = arith.addf %2, %3 : f64
          // Store the updated C[i, j]
          affine.store %4, %arg2[%arg3, %arg5] : memref<?x?xf64>
        }
      }
    }
    return
  }
}
