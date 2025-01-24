# shellcheck disable=all

BASIC_BUILD_FLAGS=(
    "-std=gnu++23"

    -O2

    -lstdc++exp
)

BASIC_USER_BUILD_FLAGS=(
    ${BASIC_BUILD_FLAGS[@]}

    -DONLINE_JUDGE
    -DATCODER

    -Wall
    -Wextra
)

EXTRA_USER_BUILD_FLAGS=(
    -fopenmp

    "-march=native"
    "-flto=auto"

    "-fconstexpr-depth=1024"
    "-fconstexpr-loop-limit=524288"
    "-fconstexpr-ops-limit=67108864"
)

USER_BOOST_LIBRARY_LINKS=(
    -lboost_atomic
    -lboost_charconv
    -lboost_chrono
    -lboost_container
    -lboost_context
    -lboost_contract
    -lboost_coroutine
    -lboost_date_time
    -lboost_exception
    -lboost_fiber
    -lboost_filesystem
    -lboost_graph
    -lboost_iostreams
    -lboost_json
    -lboost_locale
    -lboost_log -lboost_log_setup
    -lboost_math_c99 -lboost_math_c99f -lboost_math_c99l -lboost_math_tr1 -lboost_math_tr1f -lboost_math_tr1l
    -lboost_nowide
    -lboost_prg_exec_monitor
    -lboost_process
    -lboost_program_options
    -lboost_random
    -lboost_regex
    -lboost_serialization
    -lboost_stacktrace_addr2line -lboost_stacktrace_backtrace -lboost_stacktrace_basic -lboost_stacktrace_from_exception -lboost_stacktrace_noop
    -lboost_system
    -lboost_test_exec_monitor
    -lboost_thread
    -lboost_timer
    -lboost_type_erasure
    -lboost_unit_test_framework
    -lboost_url
    -lboost_wave
    -lboost_wserialization
)

USER_LIBRARY_FLAGS=(
    -I/opt/abseil/include/ -L/opt/abseil/lib/
    -I/opt/ac-library/

    -I/opt/boost/include/ -L/opt/boost/lib/ "${USER_BOOST_LIBRARY_LINKS[@]}"
    -I/usr/include/eigen3/
    -lgmpxx -lgmp
    -I/opt/range-v3/include/
    -I/opt/unordered_dense/include/
    -I/opt/z3/include/ -L/opt/z3/lib/ -Wl,-R/opt/z3/lib/ -lz3
    -I/opt/light-gbm/include/ -L/opt/light-gbm/lib/ -Wl,-R/opt/light-gbm/lib/ -l_lightgbm

    -I/opt/libtorch/include/ -I/opt/libtorch/include/torch/csrc/api/include/ -L/opt/libtorch/lib/
    -Wl,-R/opt/libtorch/lib/ -ltorch -ltorch_cpu -lc10

    -I/opt/or-tools/include/ -L/opt/or-tools/lib/
    -Wl,-R/opt/or-tools/lib/ -lortools -lprotobuf
)

INTERNAL_BUILD_FLAGS=( # for internal library building (CMake).
    ${BASIC_BUILD_FLAGS[@]}
    -w
)

USER_BUILD_FLAGS=( # for contestants.
    ${BASIC_USER_BUILD_FLAGS[@]}
    ${EXTRA_USER_BUILD_FLAGS[@]}
    ${USER_LIBRARY_FLAGS[@]}
)
