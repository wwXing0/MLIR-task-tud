// RUN: standalone-opt %s --stencil-sweep-to-scf | standalone-opt | FileCheck %s

// CHECK-LABEL: func.func @nine_point(
// CHECK-SAME: %[[A:[a-zA-Z0-9_-]+]]: memref<?x?xf64>)
// CHECK: %[[DIVISOR:[a-zA-Z0-9_-]+]] = arith.constant {{9[.]0+([eE][+]0+)?}} : f64

// Two sequential loops: rows outside, columns inside.
// CHECK: scf.for %[[I:[a-zA-Z0-9_-]+]] =
// CHECK: scf.for %[[J:[a-zA-Z0-9_-]+]] =

// [-1, -1]
// CHECK: %[[MINUS_I0:[a-zA-Z0-9_-]+]] = arith.constant -1 : index
// CHECK: %[[IM0:[a-zA-Z0-9_-]+]] = arith.addi %[[I]], %[[MINUS_I0]]
// CHECK: %[[MINUS_J0:[a-zA-Z0-9_-]+]] = arith.constant -1 : index
// CHECK: %[[JM0:[a-zA-Z0-9_-]+]] = arith.addi %[[J]], %[[MINUS_J0]]
// CHECK: %[[V0:[a-zA-Z0-9_-]+]] = memref.load %[[A]][%[[IM0]], %[[JM0]]]

// [-1, 0]
// CHECK: %[[MINUS_I1:[a-zA-Z0-9_-]+]] = arith.constant -1 : index
// CHECK: %[[IM1:[a-zA-Z0-9_-]+]] = arith.addi %[[I]], %[[MINUS_I1]]
// CHECK: %[[V1:[a-zA-Z0-9_-]+]] = memref.load %[[A]][%[[IM1]], %[[J]]]
// CHECK: %[[S1:[a-zA-Z0-9_-]+]] = arith.addf %[[V0]], %[[V1]] : f64

// [-1, 1]
// CHECK: %[[MINUS_I2:[a-zA-Z0-9_-]+]] = arith.constant -1 : index
// CHECK: %[[IM2:[a-zA-Z0-9_-]+]] = arith.addi %[[I]], %[[MINUS_I2]]
// CHECK: %[[PLUS_J2:[a-zA-Z0-9_-]+]] = arith.constant 1 : index
// CHECK: %[[JP2:[a-zA-Z0-9_-]+]] = arith.addi %[[J]], %[[PLUS_J2]]
// CHECK: %[[V2:[a-zA-Z0-9_-]+]] = memref.load %[[A]][%[[IM2]], %[[JP2]]]
// CHECK: %[[S2:[a-zA-Z0-9_-]+]] = arith.addf %[[S1]], %[[V2]] : f64

// [0, -1]
// CHECK: %[[MINUS_J3:[a-zA-Z0-9_-]+]] = arith.constant -1 : index
// CHECK: %[[JM3:[a-zA-Z0-9_-]+]] = arith.addi %[[J]], %[[MINUS_J3]]
// CHECK: %[[V3:[a-zA-Z0-9_-]+]] = memref.load %[[A]][%[[I]], %[[JM3]]]
// CHECK: %[[S3:[a-zA-Z0-9_-]+]] = arith.addf %[[S2]], %[[V3]] : f64

// [0, 0]
// CHECK: %[[V4:[a-zA-Z0-9_-]+]] = memref.load %[[A]][%[[I]], %[[J]]]
// CHECK: %[[S4:[a-zA-Z0-9_-]+]] = arith.addf %[[S3]], %[[V4]] : f64

// [0, 1]
// CHECK: %[[PLUS_J5:[a-zA-Z0-9_-]+]] = arith.constant 1 : index
// CHECK: %[[JP5:[a-zA-Z0-9_-]+]] = arith.addi %[[J]], %[[PLUS_J5]]
// CHECK: %[[V5:[a-zA-Z0-9_-]+]] = memref.load %[[A]][%[[I]], %[[JP5]]]
// CHECK: %[[S5:[a-zA-Z0-9_-]+]] = arith.addf %[[S4]], %[[V5]] : f64

// [1, -1]
// CHECK: %[[PLUS_I6:[a-zA-Z0-9_-]+]] = arith.constant 1 : index
// CHECK: %[[IP6:[a-zA-Z0-9_-]+]] = arith.addi %[[I]], %[[PLUS_I6]]
// CHECK: %[[MINUS_J6:[a-zA-Z0-9_-]+]] = arith.constant -1 : index
// CHECK: %[[JM6:[a-zA-Z0-9_-]+]] = arith.addi %[[J]], %[[MINUS_J6]]
// CHECK: %[[V6:[a-zA-Z0-9_-]+]] = memref.load %[[A]][%[[IP6]], %[[JM6]]]
// CHECK: %[[S6:[a-zA-Z0-9_-]+]] = arith.addf %[[S5]], %[[V6]] : f64

// [1, 0]
// CHECK: %[[PLUS_I7:[a-zA-Z0-9_-]+]] = arith.constant 1 : index
// CHECK: %[[IP7:[a-zA-Z0-9_-]+]] = arith.addi %[[I]], %[[PLUS_I7]]
// CHECK: %[[V7:[a-zA-Z0-9_-]+]] = memref.load %[[A]][%[[IP7]], %[[J]]]
// CHECK: %[[S7:[a-zA-Z0-9_-]+]] = arith.addf %[[S6]], %[[V7]] : f64

// [1, 1]
// CHECK: %[[PLUS_I8:[a-zA-Z0-9_-]+]] = arith.constant 1 : index
// CHECK: %[[IP8:[a-zA-Z0-9_-]+]] = arith.addi %[[I]], %[[PLUS_I8]]
// CHECK: %[[PLUS_J8:[a-zA-Z0-9_-]+]] = arith.constant 1 : index
// CHECK: %[[JP8:[a-zA-Z0-9_-]+]] = arith.addi %[[J]], %[[PLUS_J8]]
// CHECK: %[[V8:[a-zA-Z0-9_-]+]] = memref.load %[[A]][%[[IP8]], %[[JP8]]]
// CHECK: %[[S8:[a-zA-Z0-9_-]+]] = arith.addf %[[S7]], %[[V8]] : f64

// Divide and write back.
// CHECK: %[[RESULT:[a-zA-Z0-9_-]+]] = arith.divf %[[S8]], %[[DIVISOR]] : f64
// CHECK: memref.store %[[RESULT]], %[[A]][%[[I]], %[[J]]]
// CHECK: return
func.func @nine_point(%A: memref<?x?xf64>) {
  stencil.sweep %A
    offsets [[-1, -1], [-1, 0], [-1, 1],
             [0, -1], [0, 0], [0, 1],
             [1, -1], [1, 0], [1, 1]]
    divisor(9.0) : memref<?x?xf64>
  return
}

// CHECK-LABEL: func.func @custom_order(
// CHECK-SAME: %[[CUSTOM_A:[a-zA-Z0-9_-]+]]: memref<?x?xf64>)
// CHECK: %[[CUSTOM_DIVISOR:[a-zA-Z0-9_-]+]] = arith.constant {{3[.]0+([eE][+]0+)?}} : f64

// Two sequential loops: rows outside, columns inside.
// CHECK: scf.for %[[CI:[a-zA-Z0-9_-]+]] =
// CHECK: scf.for %[[CJ:[a-zA-Z0-9_-]+]] =

// [1, 0]
// CHECK: %[[PLUS0:[a-zA-Z0-9_-]+]] = arith.constant 1 : index
// CHECK: %[[IP0:[a-zA-Z0-9_-]+]] = arith.addi %[[CI]], %[[PLUS0]]
// CHECK: %[[C0:[a-zA-Z0-9_-]+]] = memref.load %[[CUSTOM_A]][%[[IP0]], %[[CJ]]]

// [-1, 0]
// CHECK: %[[MINUS:[a-zA-Z0-9_-]+]] = arith.constant -1 : index
// CHECK: %[[IM:[a-zA-Z0-9_-]+]] = arith.addi %[[CI]], %[[MINUS]]
// CHECK: %[[C1:[a-zA-Z0-9_-]+]] = memref.load %[[CUSTOM_A]][%[[IM]], %[[CJ]]]
// CHECK: %[[SUM0:[a-zA-Z0-9_-]+]] = arith.addf %[[C0]], %[[C1]] : f64

// [1, 0] again
// CHECK: %[[PLUS1:[a-zA-Z0-9_-]+]] = arith.constant 1 : index
// CHECK: %[[IP1:[a-zA-Z0-9_-]+]] = arith.addi %[[CI]], %[[PLUS1]]
// CHECK: %[[C2:[a-zA-Z0-9_-]+]] = memref.load %[[CUSTOM_A]][%[[IP1]], %[[CJ]]]
// CHECK: %[[SUM1:[a-zA-Z0-9_-]+]] = arith.addf %[[SUM0]], %[[C2]] : f64

// Divide and write back.
// CHECK: %[[CUSTOM_RESULT:[a-zA-Z0-9_-]+]] = arith.divf %[[SUM1]], %[[CUSTOM_DIVISOR]] : f64
// CHECK: memref.store %[[CUSTOM_RESULT]], %[[CUSTOM_A]][%[[CI]], %[[CJ]]]
// CHECK: return
func.func @custom_order(%A: memref<?x?xf64>) {
  stencil.sweep %A offsets [[1, 0], [-1, 0], [1, 0]]
    divisor(3.0) : memref<?x?xf64>
  return
}


// CHECK-LABEL: func.func @single_neighbour(
// CHECK-SAME: %[[SINGLE_A:[a-zA-Z0-9_-]+]]: memref<?x?xf64>)
// CHECK: %[[SINGLE_DIVISOR:[a-zA-Z0-9_-]+]] = arith.constant {{3[.]0+([eE][+]0+)?}} : f64

// Two sequential loops: rows outside, columns inside.
// CHECK: scf.for %[[SI:[a-zA-Z0-9_-]+]] =
// CHECK: scf.for %[[SJ:[a-zA-Z0-9_-]+]] =

// [0, 0]
// CHECK: %[[SINGLE:[a-zA-Z0-9_-]+]] = memref.load %[[SINGLE_A]][%[[SI]], %[[SJ]]]

// Divide and write back.
// CHECK: %[[SINGLE_RESULT:[a-zA-Z0-9_-]+]] = arith.divf %[[SINGLE]], %[[SINGLE_DIVISOR]] : f64
// CHECK: memref.store %[[SINGLE_RESULT]], %[[SINGLE_A]][%[[SI]], %[[SJ]]]
// CHECK: return
func.func @single_neighbour(%A: memref<?x?xf64>) {
  stencil.sweep %A offsets [[0, 0]] divisor(3.0) : memref<?x?xf64>
  return
}

// CHECK-LABEL: func.func @empty_static(
// CHECK-NEXT: return
func.func @empty_static(%A: memref<2x5xf64>) {
  stencil.sweep %A offsets [[-1, 0], [1, 0]]
    divisor(2.0) : memref<2x5xf64>
  return
}

