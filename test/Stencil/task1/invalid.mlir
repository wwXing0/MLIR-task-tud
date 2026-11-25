// RUN: standalone-opt %s --split-input-file --verify-diagnostics

func.func @apply_empty_offsets(%A: memref<?x?xf64>, %B: memref<?x?xf64>) {
  // expected-error @+1 {{requires a non-empty offsets list}}
  stencil.apply ins(%A : memref<?x?xf64>) outs(%B : memref<?x?xf64>)
    offsets [] scale(0.2)
  return
}

// -----

func.func @sweep_empty_offsets(%A: memref<?x?xf64>) {
  // expected-error @+1 {{requires a non-empty offsets list}}
  stencil.sweep %A offsets [] divisor(9.0) : memref<?x?xf64>
  return
}

// -----

func.func @apply_short_offset(%A: memref<?x?xf64>, %B: memref<?x?xf64>) {
  // expected-error @+1 {{each offset should contain exactly two integers}}
  stencil.apply ins(%A : memref<?x?xf64>) outs(%B : memref<?x?xf64>)
    offsets [[0]] scale(0.2)
  return
}

// -----

func.func @sweep_long_offset(%A: memref<?x?xf64>) {
  // expected-error @+1 {{each offset should contain exactly two integers}}
  stencil.sweep %A offsets [[0, 0, 0]] divisor(9.0) : memref<?x?xf64>
  return
}

// -----

func.func @apply_row_mismatch(%A: memref<4x5xf64>, %B: memref<6x5xf64>) {
  // expected-error @+1 {{input and output types should be compatible}}
  stencil.apply ins(%A : memref<4x5xf64>) outs(%B : memref<6x5xf64>)
    offsets [[0, 0]] scale(0.2)
  return
}

// -----

func.func @apply_column_mismatch(%A: memref<?x5xf64>, %B: memref<?x6xf64>) {
  // expected-error @+1 {{input and output types should be compatible}}
  stencil.apply ins(%A : memref<?x5xf64>) outs(%B : memref<?x6xf64>)
    offsets [[0, 0]] scale(0.2)
  return
}

// -----

func.func @apply_same_operand(%A: memref<?x?xf64>) {
  // expected-error @+1 {{input and output operands should be different for an out-of-place pass}}
  stencil.apply ins(%A : memref<?x?xf64>) outs(%A : memref<?x?xf64>)
    offsets [[0, 0]] scale(0.2)
  return
}