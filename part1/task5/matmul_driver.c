#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    double *allocated;
    double *aligned;
    int64_t offset;
    int64_t sizes[2];
    int64_t strides[2];
} MemRef2D;

extern void _mlir_ciface_matmul_original(MemRef2D *A, MemRef2D *B, MemRef2D *C);
extern void _mlir_ciface_matmul_interchanged(MemRef2D *A, MemRef2D *B, MemRef2D *C);

MemRef2D memref(double *data, int64_t rows, int64_t cols)
{
    MemRef2D result = {data, data, 0, {rows, cols}, {cols, 1}};
    return result;
}

int compare_results(const char *label, const double *data,
                           const double *expected, size_t count)
{
    int identical = memcmp(data, expected, count * sizeof(*expected)) == 0;
    printf("%s: %s\n", label, identical ? "YES" : "NO");
    return identical;
}

int main(void)
{
    const int64_t M = 512;
    const int64_t K = 768;
    const int64_t N = 1024;

    printf("M=%lld, K=%lld, N=%lld\n",
           (long long)M, (long long)K, (long long)N);

    double *A = malloc(M * K * sizeof(double));
    double *B = malloc(K * N * sizeof(double));
    double *C_original = malloc(M * N * sizeof(double));
    double *C_interchanged = malloc(M * N * sizeof(double));
    double *ref = malloc(M * N * sizeof(double));

    if (!A || !B || !C_original || !C_interchanged || !ref) {
        fprintf(stderr, "Allocation failed\n");
        free(A);
        free(B);
        free(C_original);
        free(C_interchanged);
        free(ref);
        return 2;
    }

    // Fixed seed for reproducible inputs in [-1, 1].
    srand(1);
    for (int64_t p = 0; p < M * K; ++p)
        A[p] = 2.0 * ((double)rand() / RAND_MAX) - 1.0;

    for (int64_t p = 0; p < K * N; ++p)
        B[p] = 2.0 * ((double)rand() / RAND_MAX) - 1.0;

    for (int64_t p = 0; p < M * N; ++p)
        C_original[p] = C_interchanged[p] = ref[p] = 1.0;

    // C reference implementation in i -> j -> k order.
    for (int64_t i = 0; i < M; ++i)
        for (int64_t j = 0; j < N; ++j)
            for (int64_t k = 0; k < K; ++k)
                ref[i * N + j] += A[i * K + k] * B[k * N + j];

    MemRef2D a = memref(A, M, K);
    MemRef2D b = memref(B, K, N);
    MemRef2D c_original = memref(C_original, M, N);
    MemRef2D c_interchanged = memref(C_interchanged, M, N);

    _mlir_ciface_matmul_original(&a, &b, &c_original);
    _mlir_ciface_matmul_interchanged(&a, &b, &c_interchanged);

    size_t count = (size_t)(M * N);
    int original_matches = compare_results(
        "Original vs reference", C_original, ref, count);
    int interchanged_matches = compare_results(
        "Interchanged vs reference", C_interchanged, ref, count);
    int passed = original_matches && interchanged_matches;

    printf("%s (bit-identical comparison)\n", passed ? "PASS" : "FAIL");

    free(A);
    free(B);
    free(C_original);
    free(C_interchanged);
    free(ref);

    return passed ? 0 : 1;
}
