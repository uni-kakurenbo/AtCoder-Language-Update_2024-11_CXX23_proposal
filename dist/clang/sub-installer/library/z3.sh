#!/bin/bash
########## AUTO-GENERATED ##########
# Do not modify this file manually #
####################################
VERSION="4.15.2"

set -eu
if "${AC_NO_BUILD_z3:-false}"; then exit 0; fi

cd "${AC_TEMP_DIR}"

echo "::group::Z3"

sudo mkdir -p ./z3

sudo wget -q "https://github.com/Z3Prover/z3/archive/refs/tags/z3-${VERSION}.tar.gz" -O ./z3.tar.gz
sudo tar -I pigz -xf ./z3.tar.gz -C ./z3 --strip-components 1

cd ./z3

sudo mkdir -p ./build && cd ./build

sudo cmake "${CMAKE_ENVIRONMENT[@]}" \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH="${AC_INSTALL_DIR}" \
    -DCMAKE_CXX_FLAGS:STRING="${INTERNALL_BUILD_FLAGS[*]}" \
    ..

sudo cmake --build . --target install

echo "::endgroup::"
