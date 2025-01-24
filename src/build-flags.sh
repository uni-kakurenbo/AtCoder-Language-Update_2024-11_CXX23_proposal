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
    -labsl_atomic_hook_test_helper.a
    -labsl_bad_any_cast_impl.a
    -labsl_bad_optional_access.a
    -labsl_bad_variant_access.a
    -labsl_base.a
    -labsl_city.a
    -labsl_civil_time.a
    -labsl_cord.a
    -labsl_cord_internal.a
    -labsl_cordz_functions.a
    -labsl_cordz_handle.a
    -labsl_cordz_info.a
    -labsl_cordz_sample_token.a
    -labsl_crc32c.a
    -labsl_crc_cord_state.a
    -labsl_crc_cpu_detect.a
    -labsl_crc_internal.a
    -labsl_debugging_internal.a
    -labsl_decode_rust_punycode.a
    -labsl_demangle_internal.a
    -labsl_demangle_rust.a
    -labsl_die_if_null.a
    -labsl_examine_stack.a
    -labsl_exception_safety_testing.a
    -labsl_exponential_biased.a
    -labsl_failure_signal_handler.a
    -labsl_flags_commandlineflag.a
    -labsl_flags_commandlineflag_internal.a
    -labsl_flags_config.a
    -labsl_flags_internal.a
    -labsl_flags_marshalling.a
    -labsl_flags_parse.a
    -labsl_flags_private_handle_accessor.a
    -labsl_flags_program_name.a
    -labsl_flags_reflection.a
    -labsl_flags_usage.a
    -labsl_flags_usage_internal.a
    -labsl_graphcycles_internal.a
    -labsl_hash.a
    -labsl_hash_generator_testing.a
    -labsl_hashtablez_sampler.a
    -labsl_int128.a
    -labsl_kernel_timeout_internal.a
    -labsl_leak_check.a
    -labsl_log_entry.a
    -labsl_log_flags.a
    -labsl_log_globals.a
    -labsl_log_initialize.a
    -labsl_log_internal_check_op.a
    -labsl_log_internal_conditions.a
    -labsl_log_internal_fnmatch.a
    -labsl_log_internal_format.a
    -labsl_log_internal_globals.a
    -labsl_log_internal_log_sink_set.a
    -labsl_log_internal_message.a
    -labsl_log_internal_nullguard.a
    -labsl_log_internal_proto.a
    -labsl_log_internal_test_actions.a
    -labsl_log_internal_test_helpers.a
    -labsl_log_internal_test_matchers.a
    -labsl_log_severity.a
    -labsl_log_sink.a
    -labsl_low_level_hash.a
    -labsl_malloc_internal.a
    -labsl_per_thread_sem_test_common.a
    -labsl_periodic_sampler.a
    -labsl_poison.a
    -labsl_pow10_helper.a
    -labsl_random_distributions.a
    -labsl_random_internal_distribution_test_util.a
    -labsl_random_internal_platform.a
    -labsl_random_internal_pool_urbg.a
    -labsl_random_internal_randen.a
    -labsl_random_internal_randen_hwaes.a
    -labsl_random_internal_randen_hwaes_impl.a
    -labsl_random_internal_randen_slow.a
    -labsl_random_internal_seed_material.a
    -labsl_random_seed_gen_exception.a
    -labsl_random_seed_sequences.a
    -labsl_raw_hash_set.a
    -labsl_raw_logging_internal.a
    -labsl_scoped_mock_log.a
    -labsl_scoped_set_env.a
    -labsl_spinlock_test_common.a
    -labsl_spinlock_wait.a
    -labsl_stack_consumption.a
    -labsl_stacktrace.a
    -labsl_status.a
    -labsl_status_matchers.a
    -labsl_statusor.a
    -labsl_str_format_internal.a
    -labsl_strerror.a
    -labsl_string_view.a
    -labsl_strings.a
    -labsl_strings_internal.a
    -labsl_symbolize.a
    -labsl_synchronization.a
    -labsl_test_instance_tracker.a
    -labsl_throw_delegate.a
    -labsl_time.a
    -labsl_time_internal_test_util.a
    -labsl_time_zone.a
    -labsl_utf8_for_code_point.a
    -labsl_vlog_config_internal.a
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
    -I/opt/abseil/include/ -L/opt/abseil/lib/ "${USER_ABSEIL_LIBRARY_LINKS[@]}"
    -Wnon-virtual-dtor -lrt # specified by abseil

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
