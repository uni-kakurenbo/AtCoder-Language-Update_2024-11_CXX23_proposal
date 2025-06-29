#!/bin/bash
set -eu
if "${AC_NO_BUILD_immer:-false}"; then exit 0; fi

cd "${AC_TEMP_DIR}"

echo "::group::immer"

sudo mkdir -p ./immer

sudo wget -q "https://github.com/arximboldi/immer/archive/refs/tags/v${VERSION}.tar.gz" -O ./immer.tar.gz
sudo tar -I pigz -xf ./immer.tar.gz -C ./immer --strip-components 1

cd ./immer

sudo cp -Trf ./immer "${AC_INSTALL_DIR}/include/immer"

echo "::endgroup::"
