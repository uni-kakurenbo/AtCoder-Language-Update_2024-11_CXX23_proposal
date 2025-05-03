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

sudo cmake "${CMAKE_ENVIRONMENT[@]}" \
    -DBUILD_CXX:BOOL=ON \
    -DBUILD_ZLIB:BOOL=ON -DBUILD_Protobuf:BOOL=ON -DBUILD_re2:BOOL=ON \
    -DUSE_COINOR:BOOL=ON -DBUILD_CoinUtils:BOOL=ON -DBUILD_Osi:BOOL=ON -DBUILD_Clp:BOOL=ON -DBUILD_Cgl:BOOL=ON -DBUILD_Cbc:BOOL=ON \
    -DUSE_GLPK:BOOL=ON -DBUILD_GLPK:BOOL=ON \
    -DUSE_HIGHS:BOOL=ON -DBUILD_HIGHS:BOOL=ON \
    -DUSE_SCIP:BOOL=ON -DBUILD_SCIP:BOOL=ON \
    -DBUILD_SAMPLES:BOOL=OFF -DBUILD_EXAMPLES:BOOL=OFF \
    -DBUILD_TESTING:BOOL="${BUILD_TESTING}" \
    -DCMAKE_PREFIX_PATH:PATH="${AC_INSTALL_DIR}" \
    -DCMAKE_INSTALL_PREFIX:PATH="${AC_INSTALL_DIR}" \
    -DBUILD_SHARED_LIBS:BOOL=OFF \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
    -DCMAKE_CXX_FLAGS:STRING="${BUILD_FLAGS[*]}" \
    ..

sudo cmake --build . --config Release --target install

if [[ -v AC_RUN_TEST ]] && [[ "${AC_RUN_TEST}" = "true" ]]; then
    sudo cmake --build . --config Release --target test --parallel "${PARALLEL}"
fi

echo "::endgroup::"
