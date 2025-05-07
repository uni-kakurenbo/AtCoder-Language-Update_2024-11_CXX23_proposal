#!/bin/bash
########## AUTO-GENERATED ##########
# Do not modify this file manually #
####################################
VERSION="15.1.0"

set -eu
if "${AC_NO_BUILD_COMPILER:-false}"; then exit 0; fi

echo "::group::GCC"

sudo mkdir -p ./gcc

sudo wget -q "http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-${VERSION}/gcc-${VERSION}.tar.gz" -O ./gcc.tar.gz
sudo tar -I pigz -xf ./gcc.tar.gz -C ./gcc --strip-components 1

cd ./gcc

sudo ./contrib/download_prerequisites

sudo ./configure \
    --host=x86_64-linux-gnu \
    --enable-languages=c++ \
    --prefix="${AC_INSTALL_DIR}" \
    --disable-bootstrap --disable-multilib

sudo make -j"${PARALLEL}" >/dev/null
sudo make install

ln -sf "${AC_INSTALL_DIR}/bin/gcc" /usr/local/bin/gcc
ln -sf "${AC_INSTALL_DIR}/bin/g++" /usr/local/bin/g++

echo "::endgroup::"
