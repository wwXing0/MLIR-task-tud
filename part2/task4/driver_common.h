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

static MemRef2D memref(double *data, int64_t rows, int64_t cols) {
  MemRef2D result = {data, data, 0, {rows, cols}, {cols, 1}};
  return result;
}

static void random_input(double *data, size_t count) {
  for (size_t p = 0; p < count; ++p)
    data[p] = 2.0 * ((double)rand() / RAND_MAX) - 1.0;
}

static int compare_results(const char *label, const double *actual,
                           const double *expected, size_t count) {
  int identical = memcmp(actual, expected, count * sizeof(*actual)) == 0;
  printf("%s: %s\n", label, identical ? "YES" : "NO");

  if (!identical) {
    for (size_t p = 0; p < count; ++p) {
      if (memcmp(&actual[p], &expected[p], sizeof(*actual)) != 0) {
        fprintf(stderr, "First mismatch at index %zu: %.17g != %.17g\n",
                p, actual[p], expected[p]);
        break;
      }
    }
  }
  return identical;
}
