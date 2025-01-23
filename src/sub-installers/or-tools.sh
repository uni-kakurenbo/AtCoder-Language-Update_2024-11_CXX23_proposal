#!/bin/bash
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
