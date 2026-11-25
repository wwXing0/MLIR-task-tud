// RUN: standalone-opt %s --stencil-apply-to-linalg | FileCheck %s
// RUN: standalone-opt %s --pass-pipeline='builtin.module(stencil-apply-to-linalg)' | FileCheck %s

// CHECK: module
module {}
