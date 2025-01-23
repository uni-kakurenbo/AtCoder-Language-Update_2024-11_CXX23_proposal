#!/bin/bash
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
