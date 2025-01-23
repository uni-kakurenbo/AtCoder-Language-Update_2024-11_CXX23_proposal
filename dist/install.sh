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

    "-fconstexpr-depth=2147483647"
    "-fconstexpr-loop-limit=2147483647"
    "-fconstexpr-ops-limit=2147483647"
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

# shellcheck disable=all
PARALLEL="$(nproc)"

VERSION=
set -eu

sudo apt-get install -y "g++-14=${VERSION}"

sudo apt-get install -y cmake pigz pbzip2


# abseil
VERSION=

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
VERSION=

set -eu

cd /tmp/

sudo wget -q "https://github.com/atcoder/ac-library/releases/download/v${VERSION}/ac-library.zip" -O ./ac-library.zip
sudo unzip -oq ./ac-library.zip -d /opt/ac-library/


# Boost
VERSION=

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
VERSION=

set -eu

sudo apt-get install -y "libeigen3-dev=${VERSION}"


# GMP
VERSION=

set -eu

sudo apt-get install -y "libgmp3-dev=${VERSION}"


# libtorch
VERSION=

set -eu

cd /tmp/

sudo wget -q "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-${VERSION}%2Bcpu.zip" -O ./libtorch.zip
sudo unzip -oq ./libtorch.zip -d ./

sudo mkdir -p /opt/libtorch/include/libtorch/
sudo mkdir -p /opt/libtorch/lib/libtorch/

sudo cp -Trf ./libtorch/include/ /opt/libtorch/include/
sudo cp -Trf ./libtorch/lib/ /opt/libtorch/lib/


# or-tools
VERSION=

set -eu

cd /tmp/

mkdir -p ./or-tools/

sudo wget -q "https://github.com/google/or-tools/archive/refs/tags/v${VERSION}.tar.gz" -O ./or-tools.tar.gz
sudo tar -I pigz -xf ./or-tools.tar.gz -C ./or-tools/ --strip-components 1

cd ./or-tools/

BUILD_TESTING=OFF
GENERATOR="Unix Makefiles"

if [[ -v RUN_TEST ]]; then
    BUILD_TESTING=ON

    if [[ ! -v ATCODER ]]; then
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

if [[ -v RUN_TESTIONS ]]; then
    sudo cmake --build ./ --config Release --target test --parallel "${PARALLEL}"
fi


# LightGBM
VERSION=

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
VERSION=

set -eu

cd /tmp/

mkdir -p ./range-v3/

sudo wget -q "https://github.com/ericniebler/range-v3/archive/refs/tags/${VERSION}.tar.gz" -O ./range-v3.tar.gz
sudo tar -I pigz -xf ./range-v3.tar.gz -C ./range-v3/ --strip-components 1

sudo mkdir -p /opt/range-v3/include/

sudo cp -Trf ./range-v3/include/ /opt/range-v3/include/


# unordered_dense
VERSION=

set -eu

cd /tmp/

mkdir -p ./unordered_dense/

sudo wget "https://github.com/martinus/unordered_dense/archive/refs/tags/v${VERSION}.tar.gz" -O ./unordered_dense.tar.gz
sudo tar -I pigz -xf ./unordered_dense.tar.gz -C ./unordered_dense/ --strip-components 1

cd ./unordered_dense/

mkdir -p ./build/ && cd ./build/

sudo cmake \
    -DCMAKE_CXX_FLAGS:STRING="${INTERNAL_BUILD_FLAGS[*]}" \
    -DCMAKE_INSTALL_PREFIX:PATH=/opt/unordered_dense/ \
    ../

sudo cmake --build ./ --target install --parallel "${PARALLEL}"


# Z3
VERSION=

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


sudo apt-get remove -y --auto-remove cmake pigz pbzip2

