#!/bin/bash
set -eu
if [[ "${AC_NO_BUILD_libtorch:-false}" == true || "${AC_VARIANT:-}" == "clang" ]]; then
    exit 0
fi

cd "${AC_TEMP_DIR}"

echo "::group::LibTorch"

sudo wget "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-${VERSION}%2Bcpu.zip" -O ./libtorch.zip
sudo unzip -o ./libtorch.zip -d .

# remove protobuf, which or-tools has as its dependencies.
sudo rm -f ./libtorch/lib/libprotobuf.a
sudo rm -f ./libtorch/lib/libprotobuf-lite.a
sudo rm -f ./libtorch/lib/libprotoc.a

sudo cp -Trf ./libtorch/include "${AC_INSTALL_DIR}/include"
sudo cp -Trf ./libtorch/lib "${AC_INSTALL_DIR}/lib"

echo "::endgroup::"
