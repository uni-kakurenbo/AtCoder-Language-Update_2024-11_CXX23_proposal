#!/bin/bash
set -eu
if "${AC_NO_BUILD_COMPILER:-false}"; then exit 0; fi

cd "${AC_TEMP_DIR}"

echo "::group::Clang"

sudo apt-get install -y lsb-release software-properties-common gnupg
sudo wget https://apt.llvm.org/llvm.sh

sudo chmod +x ./llvm.sh

sudo ./llvm.sh 19

sudo ln -s "$(which clang-19)" /usr/bin/clang
sudo ln -s "$(which clang++-19)" /usr/bin/clang++

sudo apt-get install -y libc++-19-dev
sudo apt-get purge -y --auto-remove lsb-release software-properties-common gnupg

echo "::endgroup::"
