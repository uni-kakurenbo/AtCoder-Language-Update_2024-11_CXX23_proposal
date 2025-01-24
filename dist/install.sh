#!/bin/bash
########## AUTO-GENERATED ##########
# Do not modify this file manually #
####################################

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

# shellcheck disable=all
PARALLEL="$(nproc)"

VERSION="14.2.0-4ubuntu2~24.04"
set -eu

sudo apt-get install -y "g++-14=${VERSION}"

sudo apt-get install -y git cmake pigz pbzip2


# abseil
VERSION="20240722.0"

set -eu

cd /tmp/

mkdir -p ./abseil/

sudo wget -q "https://github.com/abseil/abseil-cpp/releases/download/${VERSION}/abseil-cpp-${VERSION}.tar.gz" -O ./abseil.tar.gz
sudo tar -I pigz -xf ./abseil.tar.gz -C ./abseil/ --strip-components 1

cd ./abseil/

mkdir -p ./build/ && cd ./build/

BUILD_ARGS=(
    -DABSL_ENABLE_INSTALL:BOOL=ON
    -DABSL_PROPAGATE_CXX_STD:BOOL=ON
    -DCMAKE_INSTALL_PREFIX:PATH=/opt/abseil/
    -DCMAKE_CXX_FLAGS:STRING="${INTERNAL_BUILD_FLAGS[*]} -fPIC"
)

if [[ -v RUN_TEST ]] && [[ "${RUN_TEST}" = "true" ]]; then
    sudo cmake -DABSL_BUILD_TESTING=ON -DABSL_USE_GOOGLETEST_HEAD=ON "${BUILD_ARGS[@]}" ../

    sudo make "-j${PARALLEL}"
    sudo ctest --parallel "${PARALLEL}"
else
    sudo cmake "${BUILD_ARGS[@]}" ../
fi

sudo cmake --build ./ --target install --parallel "${PARALLEL}"


# AC-Library
VERSION="1.5.1"

set -eu

cd /tmp/

sudo wget -q "https://github.com/atcoder/ac-library/releases/download/v${VERSION}/ac-library.zip" -O ./ac-library.zip
sudo unzip -oq ./ac-library.zip -d /opt/ac-library/


# Boost
VERSION="1.86.0"

set -eu

cd /tmp/

mkdir -p ./boost/

sudo wget -q "https://archives.boost.io/release/${VERSION}/source/boost_${VERSION//./_}.tar.bz2" -O ./boost.tar.bz2
sudo tar -I pbzip2 -xf ./boost.tar.bz2 -C ./boost/ --strip-components 1

cd ./boost/

sudo ./bootstrap.sh --with-toolset=gcc --without-libraries=mpi,graph_parallel

BUILD_ARGS=(
    -d0
    "-j$(nproc)"
    "toolset=gcc"
    "threading=single"
    "variant=release"
    "link=static"
    "runtime-link=static"
    "cxxflags=${INTERNAL_BUILD_FLAGS[*]}"
)

sudo ./b2 "${BUILD_ARGS[@]}" stage
sudo ./b2 "${BUILD_ARGS[@]}" --prefix=/opt/boost/ install


# Eigen
VERSION="3.4.0-4"

set -eu

sudo apt-get install -y "libeigen3-dev=${VERSION}"


# GMP
VERSION="2:6.3.0+dfsg-2ubuntu6"

set -eu

sudo apt-get install -y "libgmp3-dev=${VERSION}"


# libtorch
VERSION="2.5.1"

set -eu

cd /tmp/

sudo wget -q "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-${VERSION}%2Bcpu.zip" -O ./libtorch.zip
sudo unzip -oq ./libtorch.zip -d ./

sudo mkdir -p /opt/libtorch/include/libtorch/
sudo mkdir -p /opt/libtorch/lib/libtorch/

sudo cp -Trf ./libtorch/include/ /opt/libtorch/include/
sudo cp -Trf ./libtorch/lib/ /opt/libtorch/lib/


# or-tools
VERSION="9.11"

set -eu

cd /tmp/

mkdir -p ./or-tools/

sudo wget -q "https://github.com/google/or-tools/archive/refs/tags/v${VERSION}.tar.gz" -O ./or-tools.tar.gz
sudo tar -I pigz -xf ./or-tools.tar.gz -C ./or-tools/ --strip-components 1

cd ./or-tools/

BUILD_TESTING=OFF
GENERATOR="Unix Makefiles"

if [[ -v RUN_TEST ]] && [[ "${RUN_TEST}" = "true" ]]; then
    BUILD_TESTING=ON

    if [[ ! -v ATCODER ]] && [[ ! -v GITHUB_WORKFLOW ]]; then
        GENERATOR="Ninja"
    fi
fi

mkdir -p ./build/ && cd ./build/

sudo cmake -G "${GENERATOR}" \
    -DBUILD_ZLIB:BOOL=ON -DBUILD_Protobuf:BOOL=ON -DBUILD_re2:BOOL=ON \
    -DUSE_COINOR:BOOL=ON -DBUILD_CoinUtils:BOOL=ON -DBUILD_Osi:BOOL=ON -DBUILD_Clp:BOOL=ON -DBUILD_Cgl:BOOL=ON -DBUILD_Cbc:BOOL=ON \
    -DUSE_GLPK:BOOL=ON -DBUILD_GLPK=ON \
    -DUSE_HIGHS:BOOL=ON -DBUILD_HIGHS=ON \
    -DUSE_SCIP:BOOL=ON -DBUILD_SCIP:BOOL=ON \
    -DBUILD_SAMPLES:BOOL=OFF -DBUILD_EXAMPLES:BOOL=OFF \
    -DBUILD_TESTING:BOOL="${BUILD_TESTING}" \
    -DCMAKE_PREFIX_PATH:PATH=/opt/abseil/ \
    -DCMAKE_INSTALL_PREFIX:PATH=/opt/or-tools/ \
    -DCMAKE_CXX_COMPILER:STRING="g++-14" \
    -DCMAKE_CXX_FLAGS="${INTERNAL_BUILD_FLAGS[*]}" \
    ../

sudo cmake --build ./ --config Release --target install --parallel "${PARALLEL}"

if [[ -v RUN_TEST ]] && [[ "${RUN_TEST}" = "true" ]]; then
    sudo cmake --build ./ --config Release --target test --parallel "${PARALLEL}"
fi


# LightGBM
VERSION="4.5.0"

set -eu

cd /tmp/

mkdir -p ./light-gbm/

sudo wget -q "https://github.com/microsoft/LightGBM/releases/download/v${VERSION}/lightgbm-${VERSION}.tar.gz" -O ./light-gbm.tar.gz
sudo tar -I pigz -xf ./light-gbm.tar.gz -C ./light-gbm/ --strip-components 1

cd ./light-gbm/

sudo rm -rf ./lightgbm/
sudo rm -rf ./external_libs/eigen/

mkdir -p ./build/ && cd ./build/

sudo cmake \
    -DCMAKE_INSTALL_PREFIX:PATH=/opt/light-gbm/ \
    -DCMAKE_CXX_COMPILER:STRING="g++-14" \
    -DCMAKE_CXX_FLAGS:STRING="${INTERNAL_BUILD_FLAGS[*]} -I/usr/include/eigen3/" \
    ../

sudo cmake --build ./ --target install --parallel "${PARALLEL}"


# range-v3
VERSION="0.12.0"

set -eu

cd /tmp/

mkdir -p ./range-v3/

sudo wget -q "https://github.com/ericniebler/range-v3/archive/refs/tags/${VERSION}.tar.gz" -O ./range-v3.tar.gz
sudo tar -I pigz -xf ./range-v3.tar.gz -C ./range-v3/ --strip-components 1

sudo mkdir -p /opt/range-v3/include/

sudo cp -Trf ./range-v3/include/ /opt/range-v3/include/


# unordered_dense
VERSION="4.4.0"

set -eu

cd /tmp/

mkdir -p ./unordered_dense/

sudo wget "https://github.com/martinus/unordered_dense/archive/refs/tags/v${VERSION}.tar.gz" -O ./unordered_dense.tar.gz
sudo tar -I pigz -xf ./unordered_dense.tar.gz -C ./unordered_dense/ --strip-components 1

cd ./unordered_dense/

mkdir -p ./build/ && cd ./build/

sudo cmake \
    -DCMAKE_CXX_COMPILER:STRING="g++-14" \
    -DCMAKE_CXX_FLAGS:STRING="${INTERNAL_BUILD_FLAGS[*]}" \
    -DCMAKE_INSTALL_PREFIX:PATH=/opt/unordered_dense/ \
    ../

sudo cmake --build ./ --target install --parallel "${PARALLEL}"


# Z3
VERSION="4.13.3"

set -eu

cd /tmp/

mkdir -p ./z3/

sudo wget -q "https://github.com/Z3Prover/z3/archive/refs/tags/z3-${VERSION}.tar.gz" -O ./z3.tar.gz
sudo tar -I pigz -xf ./z3.tar.gz -C ./z3/ --strip-components 1

cd ./z3/

mkdir -p ./build/ && cd ./build/

sudo cmake \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/opt/z3/ \
    -DCMAKE_CXX_COMPILER:STRING="g++-14" \
    -DCMAKE_CXX_FLAGS:STRING="${INTERNAL_BUILD_FLAGS[*]}" \
    ../

sudo make install "-j${PARALLEL}"


sudo apt-get remove -y --auto-remove git cmake pigz pbzip2

