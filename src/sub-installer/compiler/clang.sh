#!/bin/bash
set +u
if [[ ${AC_NO_BUILD_COMPILER} ]]; then exit 0; fi
set -eu

echo "::group::Clang"

sudo apt-get install -y lsb-release software-properties-common gnupg
sudo wget https://apt.llvm.org/llvm.sh

sudo chmod +x ./llvm.sh

sudo ./llvm.sh 19

sudo apt-get install -y libc++-19-dev

sudo apt-get purge -y --auto-remove lsb-release software-properties-common gnupg

echo "::endgroup::"
