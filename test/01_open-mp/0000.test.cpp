#include <print>
#include <omp.h>

signed main() {
    std::println("max threads: {}", omp_get_max_threads());
}
