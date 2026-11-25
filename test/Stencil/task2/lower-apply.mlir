// RUN: standalone-opt %s --stencil-apply-to-linalg | standalone-opt | FileCheck %s

// CHECK: #[[ID:[a-zA-Z0-9_]+]] = affine_map<(d0, d1) -> (d0, d1)>

// CHECK-LABEL: func.func @five_point(
// CHECK-SAME: %[[A:[a-zA-Z0-9_]+]]: memref<?x?xf64>, %[[B:[a-zA-Z0-9_]+]]: memref<?x?xf64>)
// CHECK: %[[V0:[a-zA-Z0-9_]+]] = memref.subview %[[A]][1, 1] [%[[H:[a-zA-Z0-9_]+]], %[[W:[a-zA-Z0-9_]+]]] [1, 1]
// CHECK: %[[V1:[a-zA-Z0-9_]+]] = memref.subview %[[A]][1, 0] [%[[H]], %[[W]]] [1, 1]
// CHECK: %[[V2:[a-zA-Z0-9_]+]] = memref.subview %[[A]][1, 2] [%[[H]], %[[W]]] [1, 1]
// CHECK: %[[V3:[a-zA-Z0-9_]+]] = memref.subview %[[A]][2, 1] [%[[H]], %[[W]]] [1, 1]
// CHECK: %[[V4:[a-zA-Z0-9_]+]] = memref.subview %[[A]][0, 1] [%[[H]], %[[W]]] [1, 1]
// CHECK: %[[OUT:[a-zA-Z0-9_]+]] = memref.subview %[[B]][1, 1] [%[[H]], %[[W]]] [1, 1]
// CHECK: %[[SCALE:[a-zA-Z0-9_]+]] = arith.constant {{(0[.]20*|2[.]0+[eE]-0?1)}} : f64
// CHECK: linalg.generic
// CHECK-SAME: indexing_maps = [#[[ID]], #[[ID]], #[[ID]], #[[ID]], #[[ID]], #[[ID]]]
// CHECK-SAME: iterator_types = ["parallel", "parallel"]
// CHECK-SAME: ins(%[[V0]], %[[V1]], %[[V2]], %[[V3]], %[[V4]]
// CHECK-SAME: outs(%[[OUT]]
// CHECK: ^bb0(%[[X0:[a-zA-Z0-9_]+]]: f64, %[[X1:[a-zA-Z0-9_]+]]: f64, %[[X2:[a-zA-Z0-9_]+]]: f64, %[[X3:[a-zA-Z0-9_]+]]: f64, %[[X4:[a-zA-Z0-9_]+]]: f64,
// CHECK: %[[S1:[a-zA-Z0-9_]+]] = arith.addf %[[X0]], %[[X1]] : f64
// CHECK: %[[S2:[a-zA-Z0-9_]+]] = arith.addf %[[S1]], %[[X2]] : f64
// CHECK: %[[S3:[a-zA-Z0-9_]+]] = arith.addf %[[S2]], %[[X3]] : f64
// CHECK: %[[S4:[a-zA-Z0-9_]+]] = arith.addf %[[S3]], %[[X4]] : f64
// CHECK: %[[RESULT:[a-zA-Z0-9_]+]] = arith.mulf %[[S4]], %[[SCALE]] : f64
// CHECK: linalg.yield %[[RESULT]] : f64
func.func @five_point(%A: memref<?x?xf64>, %B: memref<?x?xf64>) {
  stencil.apply ins(%A : memref<?x?xf64>) outs(%B : memref<?x?xf64>)
    offsets [[0, 0], [0, -1], [0, 1], [1, 0], [-1, 0]] scale(0.2)
  return
}


// CHECK-LABEL: func.func @single_neighbour(
// CHECK-SAME: %[[SA:[a-zA-Z0-9_]+]]: memref<?x?xf64>, %[[SB:[a-zA-Z0-9_]+]]: memref<?x?xf64>)
// CHECK: %[[SIN:[a-zA-Z0-9_]+]] = memref.subview %[[SA]][0, 0] [%[[SH:[a-zA-Z0-9_]+]], %[[SW:[a-zA-Z0-9_]+]]] [1, 1]
// CHECK: %[[SOUT:[a-zA-Z0-9_]+]] = memref.subview %[[SB]][0, 0] [%[[SH]], %[[SW]]] [1, 1]
// CHECK: %[[SSCALE:[a-zA-Z0-9_]+]] = arith.constant {{(3[.]0*|3[.]0+[eE][+]0+)}} : f64
// CHECK: linalg.generic
// CHECK-SAME: indexing_maps = [#[[ID]], #[[ID]]]
// CHECK-SAME: iterator_types = ["parallel", "parallel"]
// CHECK-SAME: ins(%[[SIN]] :
// CHECK-SAME: outs(%[[SOUT]] :
// CHECK: ^bb0(%[[SINGLE:[a-zA-Z0-9_]+]]: f64, %[[SINGLE_OLD:[a-zA-Z0-9_]+]]: f64):
// CHECK-NOT: arith.addf
// CHECK: %[[SINGLE_RESULT:[a-zA-Z0-9_]+]] = arith.mulf %[[SINGLE]], %[[SSCALE]] : f64
// CHECK-NOT: arith.addf
// CHECK: linalg.yield %[[SINGLE_RESULT]] : f64
func.func @single_neighbour(%A: memref<?x?xf64>, %B: memref<?x?xf64>) {
  stencil.apply ins(%A : memref<?x?xf64>) outs(%B : memref<?x?xf64>)
    offsets [[0, 0]] scale(3.0)
  return
}

// CHECK-LABEL: func.func @empty_static(
// CHECK-NEXT: return
func.func @empty_static(%A: memref<2x5xf64>, %B: memref<2x5xf64>) {
  stencil.apply ins(%A : memref<2x5xf64>) outs(%B : memref<2x5xf64>)
    offsets [[0, 0], [0, -1], [0, 1], [1, 0], [-1, 0]] scale(0.2)
  return
}

// CHECK-LABEL: func.func @strided_views(
// CHECK-SAME: %[[ST_A:[a-zA-Z0-9_]+]]: memref<?x?xf64, strided<[?, 2], offset: ?>>, %[[ST_B:[a-zA-Z0-9_]+]]: memref<?x?xf64, strided<[?, 2], offset: ?>>)
// CHECK: %[[ST_V0:[a-zA-Z0-9_]+]] = memref.subview %[[ST_A]][0, 0] [%[[ST_H:[a-zA-Z0-9_]+]], %[[ST_W:[a-zA-Z0-9_]+]]] [1, 1]
// CHECK-SAME: to memref<?x?xf64, strided<[?, 2], offset: ?>>
// CHECK: %[[ST_V1:[a-zA-Z0-9_]+]] = memref.subview %[[ST_A]][0, 1] [%[[ST_H]], %[[ST_W]]] [1, 1]
// CHECK-SAME: to memref<?x?xf64, strided<[?, 2], offset: ?>>
// CHECK: %[[ST_OUT:[a-zA-Z0-9_]+]] = memref.subview %[[ST_B]][0, 0] [%[[ST_H]], %[[ST_W]]] [1, 1]
// CHECK-SAME: to memref<?x?xf64, strided<[?, 2], offset: ?>>
// CHECK: %[[ST_SCALE:[a-zA-Z0-9_]+]] = arith.constant {{(0[.]50*|5[.]0+[eE]-0?1)}} : f64
// CHECK: linalg.generic
// CHECK-SAME: indexing_maps = [#[[ID]], #[[ID]], #[[ID]]]
// CHECK-SAME: iterator_types = ["parallel", "parallel"]
// CHECK-SAME: ins(%[[ST_V0]], %[[ST_V1]] :
// CHECK-SAME: outs(%[[ST_OUT]] :
// CHECK: ^bb0(%[[ST_X0:[a-zA-Z0-9_]+]]: f64, %[[ST_X1:[a-zA-Z0-9_]+]]: f64, %[[ST_OLD:[a-zA-Z0-9_]+]]: f64):
// CHECK: %[[ST_SUM:[a-zA-Z0-9_]+]] = arith.addf %[[ST_X0]], %[[ST_X1]] : f64
// CHECK: %[[ST_RESULT:[a-zA-Z0-9_]+]] = arith.mulf %[[ST_SUM]], %[[ST_SCALE]] : f64
// CHECK: linalg.yield %[[ST_RESULT]] : f64
func.func @strided_views(
    %A: memref<?x?xf64, strided<[?, 2], offset: ?>>,
    %B: memref<?x?xf64, strided<[?, 2], offset: ?>>) {
  stencil.apply
    ins(%A : memref<?x?xf64, strided<[?, 2], offset: ?>>)
    outs(%B : memref<?x?xf64, strided<[?, 2], offset: ?>>)
    offsets [[0, 0], [0, 1]] scale(0.5)
  return
}
