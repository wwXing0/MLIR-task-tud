#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "driver_common.h"

extern void _mlir_ciface_kernel_seidel_2d(int64_t tsteps, MemRef2D *A);

void polybench_init_seidel(int n, double A[n][n]);
void polybench_seidel_2d(int tsteps, int n, double A[n][n]);

int main(void)
{
    const int n = 400;
    const int tsteps = 100;

    const size_t count = (size_t)n * (size_t)n;
    const size_t bytes = count * sizeof(double);
    double *A = malloc(bytes);
    double *A_ref = malloc(bytes);

    if (!A || !A_ref) {
        fprintf(stderr, "Allocation failed\n");
        free(A);
        free(A_ref);
        return 2;
    }

    printf("Seidel-2D: N=%d, TSTEPS=%d\n", n, tsteps);

    polybench_init_seidel(n, (double (*)[n])A);
    memcpy(A_ref, A, bytes);

    polybench_seidel_2d(tsteps, n, (double (*)[n])A_ref);

    MemRef2D a = memref(A, n, n);
    _mlir_ciface_kernel_seidel_2d((int64_t)tsteps, &a);

    int passed = compare_results("Seidel A vs reference", A, A_ref, count);
    printf("bit-identical comparison %s \n", passed ? "PASS" : "FAIL");

    free(A);
    free(A_ref);
    return passed ? 0 : 1;
}
