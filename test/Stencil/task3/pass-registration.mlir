// RUN: standalone-opt %s --stencil-sweep-to-scf | FileCheck %s
// RUN: standalone-opt %s --pass-pipeline='builtin.module(stencil-sweep-to-scf)' | FileCheck %s

// CHECK: module
module {}
    