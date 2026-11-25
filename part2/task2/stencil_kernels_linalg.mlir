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
      stencil.sweep %arg1 offsets [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]] divisor(9.000000e+00) : memref<?x?xf64>
    }
    return
  }
}

