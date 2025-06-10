#!/bin/bash
set -eu
if "${AC_NO_BUILD_COMPILER:-false}"; then exit 0; fi

cd "${AC_TEMP_DIR}"

echo "::group::GCC"

sudo mkdir -p ./gcc

sudo wget -q "http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-${VERSION}/gcc-${VERSION}.tar.gz" -O ./gcc.tar.gz
sudo tar -I pigz -xf ./gcc.tar.gz -C ./gcc --strip-components 1

cd ./gcc

sudo ./contrib/download_prerequisites

CC=gcc
CXX=g++

if [[ -v CCACHE_ENABLED ]]; then
    CC="ccache ${CC}"
    CXX="ccache ${CXX}"
fi

sudo mkdir -p build && cd build

sudo ../configure CC="${CC}" CXX="${CXX}" \
    --prefix="${AC_INSTALL_DIR}" \
    --enable-languages=c++ \
    --disable-bootstrap \
    --disable-multilib \
    --disable-libsanitizer \
    --disable-checking \
    --disable-nls \
    --disable-gcov \
    --disable-libada \
    --disable-libgm2

sudo make -j"${PARALLEL}" >/dev/null
sudo make install

sudo ln -sf "${AC_INSTALL_DIR}/bin/gcc" /usr/local/bin/gcc
sudo ln -sf "${AC_INSTALL_DIR}/bin/g++" /usr/local/bin/g++

echo "::endgroup::"
