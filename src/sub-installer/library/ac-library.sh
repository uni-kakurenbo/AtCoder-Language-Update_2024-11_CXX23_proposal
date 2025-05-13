#!/bin/bash
set -eu
if "${AC_NO_BUILD_ac_library:-false}"; then exit 0; fi

cd "${AC_TEMP_DIR}"

echo "::group::AC Library"

sudo mkdir -p ./ac-library

sudo wget -q "https://github.com/atcoder/ac-library/archive/refs/tags/v${VERSION}.tar.gz" -O ./ac-library.tar.gz
sudo tar -I pigz -xf ./ac-library.tar.gz -C ./ac-library --strip-components 1

sudo cp -rf ./ac-library/atcoder "${AC_INSTALL_DIR}/include"

echo "::endgroup::"
