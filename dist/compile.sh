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

USER_LIBRARY_FLAGS=(
    -I/opt/abseil/include/ -L/opt/abseil/lib/
    -I/opt/ac-library/
    -I/opt/boost/include/ -L/opt/boost/lib/
    -I/usr/include/eigen3/
    -lgmpxx -lgmp
    -I/opt/range-v3/include/
    -I/opt/unordered_dense/include/ -L/opt/unordered_dense/lib/
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

set -eu

g++-14 ./Main.cpp -o a.out "${USER_BUILD_FLAGS[@]}"
