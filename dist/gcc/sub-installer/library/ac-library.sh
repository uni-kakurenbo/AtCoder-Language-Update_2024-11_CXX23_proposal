#!/bin/bash
########## AUTO-GENERATED ##########
# Do not modify this file manually #
####################################
VERSION="1.5.1"

set -eu
if "${AC_NO_BUILD_ac_library:-false}"; then exit 0; fi

cd "${AC_TEMP_DIR}"

echo "::group::AC Library"

sudo wget -q "https://github.com/atcoder/ac-library/releases/download/v${VERSION}/ac-library.zip" -O ./ac-library.zip
sudo unzip -oq ./ac-library.zip -d ./ac-library

cp -rf ./ac-library/atcoder "${AC_INSTALL_DIR}/include"

echo "::endgroup::"
