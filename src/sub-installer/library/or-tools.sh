#!/bin/bash
set -eu
if "${AC_NO_BUILD_or_tools:-false}"; then exit 0; fi

cd "${AC_TEMP_DIR}"

echo "::group::OR-Tools"

sudo mkdir -p ./or-tools

sudo wget -q "https://github.com/google/or-tools/archive/refs/tags/v${VERSION}.tar.gz" -O ./or-tools.tar.gz
sudo tar -I pigz -xf ./or-tools.tar.gz -C ./or-tools --strip-components 1

cd ./or-tools

BUILD_TESTING=OFF

if [[ -v AC_RUN_TEST ]] && [[ "${AC_RUN_TEST}" = "true" ]]; then
    BUILD_TESTING=ON
fi

sudo mkdir -p ./build && cd ./build

sudo cmake ..

sudo cmake --build . --config Release --target install

if [[ -v AC_RUN_TEST ]] && [[ "${AC_RUN_TEST}" = "true" ]]; then
    sudo cmake --build . --config Release --target test --parallel "${PARALLEL}"
fi

echo "::endgroup::"
