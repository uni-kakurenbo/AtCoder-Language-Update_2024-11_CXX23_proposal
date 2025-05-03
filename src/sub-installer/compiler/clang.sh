#!/bin/bash
set -eu
if "${AC_NO_BUILD_COMPILER:-false}"; then exit 0; fi

cd "${AC_TEMP_DIR}"

echo "::group::Clang"

sudo wget -q "https://github.com/llvm/llvm-project/releases/download/llvmorg-${VERSION}/LLVM-${VERSION}-Linux-X64.tar.xz" -O ./llvm.tar.xz
sudo xz -dk -T0 ./llvm.tar.xz && sudo rm -rf ./llvm.tar.xz
sudo tar -xf ./llvm.tar -C /usr --strip-components 1 && sudo rm -rf ./llvm.tar

sudo ln -sf /usr/bin/clang++ /usr/bin/clang++-20

echo "::endgroup::"
