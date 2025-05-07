#!/bin/bash
########## AUTO-GENERATED ##########
# Do not modify this file manually #
####################################
VERSION="20.1.3"

set -eu
if "${AC_NO_BUILD_COMPILER:-false}"; then exit 0; fi

cd "${AC_TEMP_DIR}"

echo "::group::Clang"

sudo wget -q "https://github.com/llvm/llvm-project/releases/download/llvmorg-${VERSION}/LLVM-${VERSION}-Linux-X64.tar.xz" -O ./llvm.tar.xz
sudo xz -dk -T0 ./llvm.tar.xz && sudo rm -rf ./llvm.tar.xz
sudo tar -xf ./llvm.tar -C "${AC_INSTALL_DIR}" --strip-components 1 && sudo rm -rf ./llvm.tar

ln -sf "${AC_INSTALL_DIR}/bin/clang" /usr/local/bin/clang
ln -sf "${AC_INSTALL_DIR}/bin/clang++" /usr/local/bin/clang++
ln -sf "${AC_INSTALL_DIR}/bin/lld" /usr/local/bin/lld

echo "::endgroup::"
