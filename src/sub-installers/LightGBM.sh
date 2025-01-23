#!/bin/bash
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
