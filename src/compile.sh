#!/bin/bash
set -eu

if [[ "${AC_VARIANT}" = "gcc" ]]; then
    g++-14 ./Main.cpp -o a.out "${BUILD_FLAGS[@]}"
else
    clang++-20 ./Main.cpp -o a.out "${BUILD_FLAGS[@]}"
fi
