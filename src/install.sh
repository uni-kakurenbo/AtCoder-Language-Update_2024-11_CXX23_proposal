#!/bin/bash
set -eu

export AC_TEMP_DIR="/tmp/ac_install/${AC_VARIANT}"
export AC_INSTALL_DIR="/opt/ac_install/${AC_VARIANT}"

rm -rf "${AC_TEMP_DIR}" "${AC_INSTALL_DIR}"
sudo mkdir -p "${AC_TEMP_DIR}" "${AC_INSTALL_DIR}/include" "${AC_INSTALL_DIR}/lib"

### Compiler
if [[ "${AC_VARIANT}" == "gcc" ]]; then
    ./sub-installer/compiler/gcc.sh

    CC="gcc-14"
    CXX="g++-14"
else
    ./sub-installer/compiler/clang.sh

    { # generate 'slack' bits/stdc++.h
        sudo mkdir -p "${AC_INSTALL_DIR}/include/bits"

        find /usr/lib/llvm-19/include/c++/v1 -maxdepth 1 -type f ! -iname '__**' ! -iname '**.**' -exec echo '#include <{}>' \; |
            sudo tee "${AC_INSTALL_DIR}/include/bits/stdc++.h"
    }

    CC="clang-19"
    CXX="clang++-19"
fi

### Libraries
echo "::group::tools"
sudo apt-get install -y git cmake ninja-build pigz pbzip2
echo "::endgroup::"

CMAKE_ENVIRONMENT=(
    -G "Ninja"

    -DCFLAGS:STRING="-w"

    -DCMAKE_C_COMPILER:STRING="${CC}"
    -DCMAKE_CXX_COMPILER:STRING="${CXX}"

    -DCMAKE_INSTALL_MESSAGE:STRING="NEVER"
)

BOOST_BUILDER_CONFIG="using gcc : : ${CXX} ;"

if ccache -v; then
    echo "ccache: enabled"

    export CCACHE_ENABLED=1

    CMAKE_ENVIRONMENT+=(
        -DCMAKE_C_COMPILER_LAUNCHER:STRING="ccache"
        -DCMAKE_CXX_COMPILER_LAUNCHER:STRING="ccache"
    )

    BOOST_BUILDER_CONFIG="using ${AC_VARIANT} : : ccache ${CXX} ;"
fi

export CMAKE_ENVIRONMENT
export BOOST_BUILDER_CONFIG

./sub-installer/library/abseil.sh
./sub-installer/library/ac-library.sh
./sub-installer/library/boost.sh
./sub-installer/library/eigen.sh
./sub-installer/library/gmp.sh
./sub-installer/library/libtorch.sh
./sub-installer/library/light-gbm.sh
./sub-installer/library/or-tools.sh
./sub-installer/library/range-v3.sh
./sub-installer/library/unordered_dense.sh
./sub-installer/library/z3.sh

if [ -v ATCODER ]; then
    echo "::group::finalize"

    find "${AC_INSTALL_DIR}" \
        -name cmake -or -name pkgconfig -or -name bin -or -name share \
        -type d -print0 |
        xargs -0 sudo rm -rf

    sudo apt-get purge -y --auto-remove git cmake ninja-build pigz pbzip2

    echo "::endgroup::"
fi
