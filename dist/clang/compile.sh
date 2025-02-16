#!/bin/bash
########## AUTO-GENERATED ##########
# Do not modify this file manually #
####################################

AC_VARIANT=clang

BUILD_FLAGS=(
    "-DATCODER"
    "-DNOMINMAX"
    "-DONLINE_JUDGE"
    "-I/opt/ac_install/include"
    "-I/opt/ac_install/include/"
    "-O2"
    "-Wall"
    "-Wextra"
    "-Wno-float-conversion"
    "-Wno-implicit-float-conversion"
    "-Wno-implicit-int-float-conversion"
    "-Wno-unknown-warning-option"
    "-fconstexpr-depth=1024"
    "-fconstexpr-steps=524288"
    "-fexperimental-library"
    "-flto=auto"
    "-fuse-ld=lld"
    "-march=native"
    "-pthread"
    "-std=gnu++23"
    "-stdlib=libc++"
    "-L/opt/ac_install/lib"
    "-labsl_bad_any_cast_impl"
    "-labsl_cordz_sample_token"
    "-labsl_failure_signal_handler"
    "-labsl_flags_parse"
    "-labsl_flags_usage"
    "-labsl_flags_usage_internal"
    "-labsl_log_flags"
    "-labsl_periodic_sampler"
    "-labsl_poison"
    "-labsl_random_internal_distribution_test_util"
    "-labsl_random_distributions"
    "-labsl_random_seed_sequences"
    "-labsl_random_internal_pool_urbg"
    "-labsl_random_internal_randen"
    "-labsl_random_internal_randen_hwaes"
    "-labsl_random_internal_randen_hwaes_impl"
    "-labsl_random_internal_randen_slow"
    "-labsl_random_internal_platform"
    "-labsl_random_internal_seed_material"
    "-labsl_random_seed_gen_exception"
    "-labsl_scoped_set_env"
    "-L/opt/ac_install/lib/"
    "-lboost_atomic"
    "-lboost_charconv"
    "-lboost_chrono"
    "-lboost_container"
    "-lboost_context"
    "-lboost_contract"
    "-lboost_coroutine"
    "-lboost_date_time"
    "-lboost_exception"
    "-lboost_fiber"
    "-lboost_filesystem"
    "-lboost_graph"
    "-lboost_iostreams"
    "-lboost_json"
    "-lboost_locale"
    "-lboost_log"
    "-lboost_log_setup"
    "-lboost_math_c99"
    "-lboost_math_c99f"
    "-lboost_math_c99l"
    "-lboost_math_tr1"
    "-lboost_math_tr1f"
    "-lboost_math_tr1l"
    "-lboost_nowide"
    "-lboost_prg_exec_monitor"
    "-lboost_process"
    "-lboost_program_options"
    "-lboost_random"
    "-lboost_regex"
    "-lboost_serialization"
    "-lboost_stacktrace_from_exception"
    "-lboost_system"
    "-lboost_test_exec_monitor"
    "-lboost_thread"
    "-lboost_timer"
    "-lboost_type_erasure"
    "-lboost_unit_test_framework"
    "-lboost_url"
    "-lboost_wave"
    "-lboost_wserialization"
    "-lgmpxx"
    "-lgmp"
    "-lortools"
    "-lCbc"
    "-lCbcSolver"
    "-lCgl"
    "-lClp"
    "-lClpSolver"
    "-lCoinUtils"
    "-lGLPK"
    "-lOsi"
    "-lOsiCbc"
    "-lOsiClp"
    "-lhighs"
    "-lscip"
    "-lz"
    "-lprotobuf"
    "-labsl_log_internal_check_op"
    "-labsl_leak_check"
    "-labsl_die_if_null"
    "-labsl_log_internal_conditions"
    "-labsl_log_internal_message"
    "-labsl_examine_stack"
    "-labsl_log_internal_format"
    "-labsl_log_internal_proto"
    "-labsl_log_internal_nullguard"
    "-labsl_log_internal_log_sink_set"
    "-labsl_log_sink"
    "-labsl_log_entry"
    "-labsl_log_initialize"
    "-labsl_log_globals"
    "-labsl_vlog_config_internal"
    "-labsl_log_internal_fnmatch"
    "-labsl_log_internal_globals"
    "-labsl_statusor"
    "-labsl_status"
    "-labsl_strerror"
    "-lutf8_validity"
    "-lutf8_range"
    "-pthread"
    "-lre2"
    "-labsl_flags_internal"
    "-labsl_flags_marshalling"
    "-labsl_flags_reflection"
    "-labsl_flags_private_handle_accessor"
    "-labsl_flags_commandlineflag"
    "-labsl_flags_commandlineflag_internal"
    "-labsl_flags_config"
    "-labsl_flags_program_name"
    "-labsl_cord"
    "-labsl_cordz_info"
    "-labsl_cord_internal"
    "-labsl_cordz_functions"
    "-labsl_cordz_handle"
    "-labsl_crc_cord_state"
    "-labsl_crc32c"
    "-labsl_crc_internal"
    "-labsl_crc_cpu_detect"
    "-labsl_raw_hash_set"
    "-labsl_hash"
    "-labsl_city"
    "-labsl_bad_variant_access"
    "-labsl_low_level_hash"
    "-labsl_hashtablez_sampler"
    "-labsl_exponential_biased"
    "-labsl_bad_optional_access"
    "-labsl_str_format_internal"
    "-labsl_synchronization"
    "-labsl_graphcycles_internal"
    "-labsl_kernel_timeout_internal"
    "-labsl_stacktrace"
    "-labsl_symbolize"
    "-labsl_debugging_internal"
    "-labsl_demangle_internal"
    "-labsl_demangle_rust"
    "-labsl_decode_rust_punycode"
    "-labsl_utf8_for_code_point"
    "-labsl_malloc_internal"
    "-labsl_time"
    "-labsl_civil_time"
    "-labsl_strings"
    "-labsl_strings_internal"
    "-labsl_string_view"
    "-labsl_base"
    "-lrt"
    "-labsl_spinlock_wait"
    "-labsl_int128"
    "-labsl_throw_delegate"
    "-labsl_raw_logging_internal"
    "-labsl_log_severity"
    "-labsl_time_zone"
    "-Wl,-R/opt/ac_install/lib/"
    "-lz3"
)

set -eu

if [[ ! -v AC_VARIANT ]] || [[ "${AC_VARIANT}" = "gcc" ]]; then
    g++-14 ./Main.cpp -o a.out "${BUILD_FLAGS[@]}"
else
    clang++-19 ./Main.cpp -o a.out "${BUILD_FLAGS[@]}"
fi
