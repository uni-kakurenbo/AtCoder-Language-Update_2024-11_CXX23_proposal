#!/bin/bash
set -eu
if "${AC_NO_BUILD_unordered_dense:-false}"; then exit 0; fi

cd "${AC_TEMP_DIR}"

echo "::group::unordered_dense"

sudo mkdir -p ./unordered_dense

sudo wget "https://github.com/martinus/unordered_dense/archive/refs/tags/v${VERSION}.tar.gz" -O ./unordered_dense.tar.gz
sudo tar -I pigz -xf ./unordered_dense.tar.gz -C ./unordered_dense --strip-components 1

cd ./unordered_dense

sudo mkdir -p ./build && cd ./build

sudo cmake "${CMAKE_ENVIRONMENT[@]}" \
    -DCMAKE_INSTALL_PREFIX:PATH="${AC_INSTALL_DIR}" \
    ..

sudo cmake --build . --target install

echo "::endgroup::"
