// RUN: standalone-opt %S/../../../examples/stencil_kernels.mlir | standalone-opt | FileCheck %s

// CHECK-LABEL: func.func @kernel_jacobi_2d(
// CHECK-SAME: %[[JT:[a-zA-Z0-9_]+]]: index,
// CHECK-SAME: %[[A:[a-zA-Z0-9_]+]]: memref<?x?xf64>,
// CHECK-SAME: %[[B:[a-zA-Z0-9_]+]]: memref<?x?xf64>)
// CHECK: scf.for
// CHECK-SAME: to %[[JT]]
// CHECK-NEXT: stencil.apply ins(%[[A]] : memref<?x?xf64>) outs(%[[B]] : memref<?x?xf64>)
// CHECK-NEXT: stencil.apply ins(%[[B]] : memref<?x?xf64>) outs(%[[A]] : memref<?x?xf64>)
// CHECK-NEXT: }
// CHECK-NEXT: return

// CHECK-LABEL: func.func @kernel_seidel_2d(
// CHECK-SAME: %[[ST:[a-zA-Z0-9_]+]]: index,
// CHECK-SAME: %[[GRID:[a-zA-Z0-9_]+]]: memref<?x?xf64>)
// CHECK: scf.for
// CHECK-SAME: to %[[ST]]
// CHECK-NEXT: stencil.sweep %[[GRID]]
// CHECK-NEXT: }
// CHECK-NEXT: return
