#!/bin/bash
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
