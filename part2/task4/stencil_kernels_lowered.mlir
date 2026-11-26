#map = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @kernel_jacobi_2d(%arg0: index, %arg1: memref<?x?xf64>, %arg2: memref<?x?xf64>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %arg0 step %c1 {
      %c0_0 = arith.constant 0 : index
      %dim = memref.dim %arg1, %c0_0 : memref<?x?xf64>
      %c1_1 = arith.constant 1 : index
      %dim_2 = memref.dim %arg1, %c1_1 : memref<?x?xf64>
      %c2 = arith.constant 2 : index
      %c2_3 = arith.constant 2 : index
      %0 = arith.cmpi sgt, %dim, %c2 : index
      %1 = arith.cmpi sgt, %dim_2, %c2_3 : index
      %2 = arith.andi %0, %1 : i1
      scf.if %2 {
        %6 = arith.subi %dim, %c2 : index
        %7 = arith.subi %dim_2, %c2_3 : index
        %subview = memref.subview %arg1[1, 1] [%6, %7] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
        %subview_10 = memref.subview %arg1[1, 0] [%6, %7] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
        %subview_11 = memref.subview %arg1[1, 2] [%6, %7] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
        %subview_12 = memref.subview %arg1[2, 1] [%6, %7] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
        %subview_13 = memref.subview %arg1[0, 1] [%6, %7] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: 1>>
        %subview_14 = memref.subview %arg2[1, 1] [%6, %7] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
        %cst = arith.constant 2.000000e-01 : f64
        linalg.generic {indexing_maps = [#map, #map, #map, #map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%subview, %subview_10, %subview_11, %subview_12, %subview_13 : memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: 1>>) outs(%subview_14 : memref<?x?xf64, strided<[?, 1], offset: ?>>) {
        ^bb0(%in: f64, %in_15: f64, %in_16: f64, %in_17: f64, %in_18: f64, %out: f64):
          %8 = arith.addf %in, %in_15 : f64
          %9 = arith.addf %8, %in_16 : f64
          %10 = arith.addf %9, %in_17 : f64
          %11 = arith.addf %10, %in_18 : f64
          %12 = arith.mulf %11, %cst : f64
          linalg.yield %12 : f64
        }
      }
      %c0_4 = arith.constant 0 : index
      %dim_5 = memref.dim %arg2, %c0_4 : memref<?x?xf64>
      %c1_6 = arith.constant 1 : index
      %dim_7 = memref.dim %arg2, %c1_6 : memref<?x?xf64>
      %c2_8 = arith.constant 2 : index
      %c2_9 = arith.constant 2 : index
      %3 = arith.cmpi sgt, %dim_5, %c2_8 : index
      %4 = arith.cmpi sgt, %dim_7, %c2_9 : index
      %5 = arith.andi %3, %4 : i1
      scf.if %5 {
        %6 = arith.subi %dim_5, %c2_8 : index
        %7 = arith.subi %dim_7, %c2_9 : index
        %subview = memref.subview %arg2[1, 1] [%6, %7] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
        %subview_10 = memref.subview %arg2[1, 0] [%6, %7] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
        %subview_11 = memref.subview %arg2[1, 2] [%6, %7] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
        %subview_12 = memref.subview %arg2[2, 1] [%6, %7] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
        %subview_13 = memref.subview %arg2[0, 1] [%6, %7] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: 1>>
        %subview_14 = memref.subview %arg1[1, 1] [%6, %7] [1, 1] : memref<?x?xf64> to memref<?x?xf64, strided<[?, 1], offset: ?>>
        %cst = arith.constant 2.000000e-01 : f64
        linalg.generic {indexing_maps = [#map, #map, #map, #map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%subview, %subview_10, %subview_11, %subview_12, %subview_13 : memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: ?>>, memref<?x?xf64, strided<[?, 1], offset: 1>>) outs(%subview_14 : memref<?x?xf64, strided<[?, 1], offset: ?>>) {
        ^bb0(%in: f64, %in_15: f64, %in_16: f64, %in_17: f64, %in_18: f64, %out: f64):
          %8 = arith.addf %in, %in_15 : f64
          %9 = arith.addf %8, %in_16 : f64
          %10 = arith.addf %9, %in_17 : f64
          %11 = arith.addf %10, %in_18 : f64
          %12 = arith.mulf %11, %cst : f64
          linalg.yield %12 : f64
        }
      }
    }
    return
  }
  func.func @kernel_seidel_2d(%arg0: index, %arg1: memref<?x?xf64>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    scf.for %arg2 = %c0 to %arg0 step %c1 {
      %c0_0 = arith.constant 0 : index
      %dim = memref.dim %arg1, %c0_0 : memref<?x?xf64>
      %c1_1 = arith.constant 1 : index
      %dim_2 = memref.dim %arg1, %c1_1 : memref<?x?xf64>
      %c1_3 = arith.constant 1 : index
      %c1_4 = arith.constant 1 : index
      %c1_5 = arith.constant 1 : index
      %c1_6 = arith.constant 1 : index
      %0 = arith.subi %dim, %c1_5 : index
      %1 = arith.subi %dim_2, %c1_6 : index
      %c1_7 = arith.constant 1 : index
      %cst = arith.constant 9.000000e+00 : f64
      scf.for %arg3 = %c1_3 to %0 step %c1_7 {
        scf.for %arg4 = %c1_4 to %1 step %c1_7 {
          %c-1 = arith.constant -1 : index
          %2 = arith.addi %arg3, %c-1 : index
          %c-1_8 = arith.constant -1 : index
          %3 = arith.addi %arg4, %c-1_8 : index
          %4 = memref.load %arg1[%2, %3] : memref<?x?xf64>
          %c-1_9 = arith.constant -1 : index
          %5 = arith.addi %arg3, %c-1_9 : index
          %6 = memref.load %arg1[%5, %arg4] : memref<?x?xf64>
          %7 = arith.addf %4, %6 : f64
          %c-1_10 = arith.constant -1 : index
          %8 = arith.addi %arg3, %c-1_10 : index
          %c1_11 = arith.constant 1 : index
          %9 = arith.addi %arg4, %c1_11 : index
          %10 = memref.load %arg1[%8, %9] : memref<?x?xf64>
          %11 = arith.addf %7, %10 : f64
          %c-1_12 = arith.constant -1 : index
          %12 = arith.addi %arg4, %c-1_12 : index
          %13 = memref.load %arg1[%arg3, %12] : memref<?x?xf64>
          %14 = arith.addf %11, %13 : f64
          %15 = memref.load %arg1[%arg3, %arg4] : memref<?x?xf64>
          %16 = arith.addf %14, %15 : f64
          %c1_13 = arith.constant 1 : index
          %17 = arith.addi %arg4, %c1_13 : index
          %18 = memref.load %arg1[%arg3, %17] : memref<?x?xf64>
          %19 = arith.addf %16, %18 : f64
          %c1_14 = arith.constant 1 : index
          %20 = arith.addi %arg3, %c1_14 : index
          %c-1_15 = arith.constant -1 : index
          %21 = arith.addi %arg4, %c-1_15 : index
          %22 = memref.load %arg1[%20, %21] : memref<?x?xf64>
          %23 = arith.addf %19, %22 : f64
          %c1_16 = arith.constant 1 : index
          %24 = arith.addi %arg3, %c1_16 : index
          %25 = memref.load %arg1[%24, %arg4] : memref<?x?xf64>
          %26 = arith.addf %23, %25 : f64
          %c1_17 = arith.constant 1 : index
          %27 = arith.addi %arg3, %c1_17 : index
          %c1_18 = arith.constant 1 : index
          %28 = arith.addi %arg4, %c1_18 : index
          %29 = memref.load %arg1[%27, %28] : memref<?x?xf64>
          %30 = arith.addf %26, %29 : f64
          %31 = arith.divf %30, %cst : f64
          memref.store %31, %arg1[%arg3, %arg4] : memref<?x?xf64>
        }
      }
    }
    return
  }
}

