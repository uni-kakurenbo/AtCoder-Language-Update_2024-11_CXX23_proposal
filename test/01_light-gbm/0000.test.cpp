#include <print>
#include <LightGBM/c_api.h>

signed main() {
    std::println("{}", LGBM_SetMaxThreads(2));
}
