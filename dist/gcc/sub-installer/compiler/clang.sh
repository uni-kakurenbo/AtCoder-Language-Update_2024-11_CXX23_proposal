#!/bin/bash
########## AUTO-GENERATED ##########
# Do not modify this file manually #
####################################
VERSION="20.1.3"

set -eu
if "${AC_NO_BUILD_COMPILER:-false}"; then exit 0; fi

cd "${AC_TEMP_DIR}"

echo "::group::Clang"

sudo mkdir -p ./llvm-project

sudo wget -q "https://github.com/llvm/llvm-project/releases/download/llvmorg-${VERSION}/llvm-project-${VERSION}.src.tar.xz" -O ./llvm-project.tar.xz
sudo xz -dk -T0 ./llvm-project.tar.xz && sudo rm -rf ./llvm-project.tar.xz
sudo tar -xf ./llvm-project.tar -C ./llvm-project --strip-components 1 && sudo rm -rf ./llvm-project.tar

cd ./llvm-project

sudo mkdir -p ./build && cd ./build

sudo cmake "${CMAKE_ENVIRONMENT[@]}" \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DLLVM_ENABLE_PROJECTS:STRING="clang;lld" \
    -DLLVM_ENABLE_RUNTIMES:STRING="libcxx;libcxxabi;compiler-rt;libunwind;openmp" \
    -DLLVM_TARGETS_TO_BUILD="X86" \
    -DLLVM_USE_LINKER:STRING=lld \
    -DLLVM_INCLUDE_TESTS:BOOL=OFF \
    -DLLVM_INCLUDE_BENCHMARKS:BOOL=OFF \
    -DLLVM_INCLUDE_EXAMPLES:BOOL=OFF \
    -DLLVM_ENABLE_PEDANTIC:BOOL=OFF \
    -DLLVM_ENABLE_WARNINGS:BOOL=OFF \
    -DLIBCXX_CXX_ABI:STRING="libcxxabi" \
    -DLIBCXX_INCLUDE_BENCHMARKS:BOOL=OFF \
    -DCMAKE_INSTALL_PREFIX:PATH="${AC_INSTALL_DIR}" \
    ../llvm

sudo cmake --build .
sudo cmake --build . --target install

sudo ln -sf "${AC_INSTALL_DIR}/bin/clang" /usr/local/bin/clang
sudo ln -sf "${AC_INSTALL_DIR}/bin/clang++" /usr/local/bin/clang++
sudo ln -sf "${AC_INSTALL_DIR}/bin/lld" /usr/local/bin/lld

echo "::endgroup::"
