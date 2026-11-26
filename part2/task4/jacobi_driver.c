#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "driver_common.h"

extern void _mlir_ciface_kernel_jacobi_2d(
    int64_t tsteps, MemRef2D *A, MemRef2D *B);

void polybench_init_jacobi(int n, double A[n][n], double B[n][n]);
void polybench_jacobi_2d(int tsteps, int n, double A[n][n], double B[n][n]);

int main(void)
{
    const int n = 400;
    const int tsteps = 100;

    const size_t count = (size_t)n * (size_t)n;
    const size_t bytes = count * sizeof(double);
    double *A = malloc(bytes);
    double *B = malloc(bytes);
    double *A_ref = malloc(bytes);
    double *B_ref = malloc(bytes);

    if (!A || !B || !A_ref || !B_ref) {
        fprintf(stderr, "Allocation failed\n");
        free(A);
        free(B);
        free(A_ref);
        free(B_ref);
        return 2;
    }

    printf("Jacobi-2D: N=%d, TSTEPS=%d\n", n, tsteps);

    polybench_init_jacobi(n, (double (*)[n])A, (double (*)[n])B);
    memcpy(A_ref, A, bytes);
    memcpy(B_ref, B, bytes);

    polybench_jacobi_2d(tsteps, n, (double (*)[n])A_ref, (double (*)[n])B_ref);

    MemRef2D a = memref(A, n, n);
    MemRef2D b = memref(B, n, n);
    _mlir_ciface_kernel_jacobi_2d((int64_t)tsteps, &a, &b);

    int a_matches = compare_results("Jacobi A vs reference", A, A_ref, count);
    int b_matches = compare_results("Jacobi B vs reference", B, B_ref, count);
    int passed = a_matches && b_matches;
    printf("bit-identical comparison %s \n", passed ? "PASS" : "FAIL");

    free(A);
    free(B);
    free(A_ref);
    free(B_ref);
    return passed ? 0 : 1;
}
