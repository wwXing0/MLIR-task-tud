#mapA = affine_map<(i, j, k) -> (i, k)>
#mapB = affine_map<(i, j, k) -> (k, j)>
#mapC = affine_map<(i, j, k) -> (i, j)>

module {
  func.func @matmul_generic(
      %A: memref<?x?xf64>,
      %B: memref<?x?xf64>,
      %C: memref<?x?xf64>) {

    linalg.generic {
      indexing_maps = [#mapA, #mapB, #mapC],
      iterator_types = ["parallel", "parallel", "reduction"]
    }
        ins(%A, %B : memref<?x?xf64>, memref<?x?xf64>)
        outs(%C : memref<?x?xf64>) {
    ^bb0(%a: f64, %b: f64, %c: f64):
      %prod = arith.mulf %a, %b : f64
      %sum = arith.addf %c, %prod : f64
      linalg.yield %sum : f64
    }

    func.return
  }
}
