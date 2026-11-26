/*
 * Reference computations extracted from PolyBench/C 4.2.1-beta.
 * Original source files:
 *   stencils/jacobi-2d/jacobi-2d.c
 *   stencils/seidel-2d/seidel-2d.c
 *
 * Keep the original initialization, two-dimensional indexing and arithmetic
 * order. Use double arrays and runtime bounds in place of PolyBench macros,
 * and expose the functions for our C drivers.
 */

void polybench_init_jacobi(int n, double A[n][n], double B[n][n]) {
  int i, j;

  for (i = 0; i < n; i++)
    for (j = 0; j < n; j++) {
      A[i][j] = ((double)i * (j + 2) + 2) / n;
      B[i][j] = ((double)i * (j + 3) + 3) / n;
    }
}

void polybench_jacobi_2d(int tsteps, int n, double A[n][n], double B[n][n]) {
  int t, i, j;
  for (t = 0; t < tsteps; t++) {
    for (i = 1; i < n - 1; i++)
      for (j = 1; j < n - 1; j++)
        B[i][j] = 0.2 * (A[i][j] + A[i][j - 1] + A[i][1 + j] + A[1 + i][j] +
                         A[i - 1][j]);
    for (i = 1; i < n - 1; i++)
      for (j = 1; j < n - 1; j++)
        A[i][j] = 0.2 * (B[i][j] + B[i][j - 1] + B[i][1 + j] + B[1 + i][j] +
                         B[i - 1][j]);
  }
}

void polybench_init_seidel(int n, double A[n][n]) {
  int i, j;
  for (i = 0; i < n; i++)
    for (j = 0; j < n; j++)
      A[i][j] = ((double)i * (j + 2) + 2) / n;
}

void polybench_seidel_2d(int tsteps, int n, double A[n][n]) {
  int t, i, j;
  for (t = 0; t <= tsteps - 1; t++)
    for (i = 1; i <= n - 2; i++)
      for (j = 1; j <= n - 2; j++)
        A[i][j] = (A[i - 1][j - 1] + A[i - 1][j] + A[i - 1][j + 1] +
                   A[i][j - 1] + A[i][j] + A[i][j + 1] + A[i + 1][j - 1] +
                   A[i + 1][j] + A[i + 1][j + 1]) /
                  9.0;
}
