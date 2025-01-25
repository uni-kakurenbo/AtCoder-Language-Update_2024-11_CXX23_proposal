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

USER_ABSEIL_LIBRARY_LINKS=(
    -labsl_bad_any_cast_impl
    -labsl_bad_optional_access
    -labsl_bad_variant_access
    -labsl_base
    -labsl_city
    -labsl_civil_time
    -labsl_cord
    -labsl_cord_internal
    -labsl_cordz_functions
    -labsl_cordz_handle
    -labsl_cordz_info
    -labsl_cordz_sample_token
    -labsl_crc32c
    -labsl_crc_cord_state
    -labsl_crc_cpu_detect
    -labsl_crc_internal
    -labsl_debugging_internal
    -labsl_decode_rust_punycode
    -labsl_demangle_internal
    -labsl_demangle_rust
    -labsl_die_if_null
    -labsl_examine_stack
    -labsl_exponential_biased
    -labsl_failure_signal_handler
    -labsl_flags_commandlineflag
    -labsl_flags_commandlineflag_internal
    -labsl_flags_config
    -labsl_flags_internal
    -labsl_flags_marshalling
    -labsl_flags_parse
    -labsl_flags_private_handle_accessor
    -labsl_flags_program_name
    -labsl_flags_reflection
    -labsl_flags_usage
    -labsl_flags_usage_internal
    -labsl_graphcycles_internal
    -labsl_hash
    -labsl_hashtablez_sampler
    -labsl_int128
    -labsl_kernel_timeout_internal
    -labsl_leak_check
    -labsl_log_entry
    -labsl_log_flags
    -labsl_log_globals
    -labsl_log_initialize
    -labsl_log_internal_check_op
    -labsl_log_internal_conditions
    -labsl_log_internal_fnmatch
    -labsl_log_internal_format
    -labsl_log_internal_globals
    -labsl_log_internal_log_sink_set
    -labsl_log_internal_message
    -labsl_log_internal_nullguard
    -labsl_log_internal_proto
    -labsl_log_severity
    -labsl_log_sink
    -labsl_low_level_hash
    -labsl_malloc_internal
    -labsl_periodic_sampler
    -labsl_poison
    -labsl_random_distributions
    -labsl_random_internal_distribution_test_util
    -labsl_random_internal_platform
    -labsl_random_internal_pool_urbg
    -labsl_random_internal_randen
    -labsl_random_internal_randen_hwaes
    -labsl_random_internal_randen_hwaes_impl
    -labsl_random_internal_randen_slow
    -labsl_random_internal_seed_material
    -labsl_random_seed_gen_exception
    -labsl_random_seed_sequences
    -labsl_raw_hash_set
    -labsl_raw_logging_internal
    -labsl_scoped_set_env
    -labsl_spinlock_wait
    -labsl_stacktrace
    -labsl_status
    -labsl_statusor
    -labsl_str_format_internal
    -labsl_strerror
    -labsl_string_view
    -labsl_strings
    -labsl_strings_internal
    -labsl_symbolize
    -labsl_synchronization
    -labsl_throw_delegate
    -labsl_time
    -labsl_time_zone
    -labsl_utf8_for_code_point
    -labsl_vlog_config_internal
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

USER_ORTOOLS_LIBRARY_LINKS=(
    -lCbc
    -lCbcSolver
    -lCgl
    -lClp
    -lClpSolver
    -lCoinUtils
    -lGLPK
    -lOsi
    -lOsiCbc
    -lOsiClp
    -lhighs
    -lortools
    # -lortools_flatzinc
    # -lprotobuf-lite
    -lprotobuf
    # -lprotoc
    -lre2
    -lscip
    -lutf8_range
    -lutf8_validity
    -lz
)

USER_LIBRARY_FLAGS=(
    -I/opt/abseil/include/ -L/opt/abseil/lib/ "${USER_ABSEIL_LIBRARY_LINKS[@]}"
    -Wnon-virtual-dtor -lrt # specified by abseil

    -I/opt/ac-library/

    -I/opt/boost/include/ -L/opt/boost/lib/ "${USER_BOOST_LIBRARY_LINKS[@]}"

    -I/usr/include/eigen3/

    -lgmpxx -lgmp

    -I/opt/range-v3/include/

    -I/opt/unordered_dense/include/ -L/opt/unordered_dense/lib/

    -I/opt/z3/include/ -L/opt/z3/lib/ -Wl,-R/opt/z3/lib/ -lz3

    -I/opt/light-gbm/include/ -L/opt/light-gbm/lib/ -Wl,-R/opt/light-gbm/lib/ -l_lightgbm

    -I/opt/libtorch/include/ -I/opt/libtorch/include/torch/csrc/api/include/ -L/opt/libtorch/lib/
    -Wl,-R/opt/libtorch/lib/ -ltorch -ltorch_cpu -lc10

    -I/opt/or-tools/include/ -L/opt/or-tools/lib/
    -Wl,-R/opt/or-tools/lib/ -lortools -lhighs -lprotobuf "${USER_ORTOOLS_LIBRARY_LINKS[@]}"
)

USER_LIBRARY_FLAGS=( # deplicate link info for foolish linker
    ${USER_LIBRARY_FLAGS[@]}
    ${USER_LIBRARY_FLAGS[@]}
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
