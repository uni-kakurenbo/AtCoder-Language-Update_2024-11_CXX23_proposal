#!/bin/bash
########## AUTO-GENERATED ##########
# Do not modify this file manually #
####################################

# shellcheck disable=all
PARALLEL="$(($(nproc) + 2))"

AC_VARIANT=clang

INTERNALL_BUILD_FLAGS=(
    "-fuse-ld=lld"
    "-rtlib=compiler-rt"
    "-std=gnu++23"
    "-stdlib=libc++"
    "-unwindlib=libunwind"
    "-w"
    "-Wl,-R::install_dir::/lib/x86_64-unknown-linux-gnu"
    "-Wl,-R::install_dir::/lib/clang/20/lib/x86_64-unknown-linux-gnu"
)

PRECOMPILE_BUILD_FLAGS=(
    "-DATCODER"
    "-DONLINE_JUDGE"
    "-O2"
    "-Wall"
    "-Wextra"
    "-fconstexpr-depth=1024"
    "-fconstexpr-steps=524288"
    "-fexperimental-library"
    "-flto=auto"
    "-fprebuilt-module-path=."
    "-ftrivial-auto-var-init=zero"
    "-fuse-ld=lld"
    "-march=native"
    "-pthread"
    "-rtlib=compiler-rt"
    "-std=gnu++23"
    "-stdlib=libc++"
    "-unwindlib=libunwind"
    "-Wl,--as-needed"
    "-Wl,-R::install_dir::/lib/x86_64-unknown-linux-gnu"
    "-Wl,-R::install_dir::/lib/clang/20/lib/x86_64-unknown-linux-gnu"
    "-fopenmp"
    "-fopenmp-extensions"
)

set -eu

ARGUMENTS=("$0")
while (($# > 0)); do
    case "$1" in
    --variant)
        AC_VARIANT="$2"
        shift
        ;;
    --install-prefix)
        AC_INSTALL_PREFIX="$2"
        shift
        ;;
    --install-dir)
        AC_INSTALL_DIR="$2"
        shift
        ;;
    --temp-dir)
        AC_TEMP_DIR="$2"
        shift
        ;;
    -h | --help | ?)
        echo "{--option}       / {ENVIRONMENT}      [default] (info)"
        echo "--variant        / AC_VARIANT         [gcc]"
        echo "--install-prefix / AC_INSTALL_PREFIX  [/opt/atcoder] (ignored iif --install-dir is given)"
        echo "--install-dir    / AC_INSTALL_DIR     [\${install-prefix}/\${variant}']"
        echo "--temp-dir       / AC_TEMP_DIR        [/temp/atcoder/\${variant}]"
        exit 0
        ;;
    -*)
        echo "$(tput setaf 1)ERROR: $(tput sgr0)Unexpected command option: $(tput setaf 5)$1"
        exit 1
        ;;
    *)
        ARGUMENTS=("${ARGUMENTS[@]}" "$1")
        ;;
    esac

    shift
done

if [[ ! -v AC_VARIANT ]]; then
    export AC_VARIANT="gcc"
fi

if [[ ! -v AC_INSTALL_PREFIX ]]; then
    export AC_INSTALL_PREFIX="/opt/atcoder"
fi

if [[ ! -v AC_TEMP_DIR ]]; then
    export AC_TEMP_DIR="/tmp/atcoder/${AC_VARIANT}"
fi

if [[ ! -v AC_INSTALL_DIR ]]; then
    export AC_INSTALL_DIR="${AC_INSTALL_PREFIX}/${AC_VARIANT}"
fi

sudo mkdir -p /etc/atcoder/
echo "${AC_INSTALL_DIR}" | sudo tee /etc/atcoder/install_dir.txt

# shellcheck disable=SC2016
INTERNALL_BUILD_FLAGS=("${INTERNALL_BUILD_FLAGS[@]/'::install_dir::'/${AC_INSTALL_DIR}}")
PRECOMPILE_BUILD_FLAGS=("${PRECOMPILE_BUILD_FLAGS[@]/'::install_dir::'/${AC_INSTALL_DIR}}")

sudo mkdir -p "${AC_TEMP_DIR}" "${AC_INSTALL_DIR}/include" "${AC_INSTALL_DIR}/lib"

echo "::group::tools"
sudo apt-get install -y git cmake lld ninja-build pigz pbzip2

echo "::endgroup::"

### Configure
CMAKE_ENVIRONMENT=(
    -G "Ninja"
    -DLINK_FLAGS:STRING="-fuse-ld=lld"
    -DCFLAGS:STRING="-w"
    -DCXXFLAGS:STRING="-w"
    -DCMAKE_INSTALL_MESSAGE:STRING=NEVER
)

if ccache -v; then
    echo "ccache enabled"

    export CCACHE_ENABLED=1

    CMAKE_ENVIRONMENT+=(
        -DCMAKE_C_COMPILER_LAUNCHER:STRING=ccache
        -DCMAKE_CXX_COMPILER_LAUNCHER:STRING=ccache
    )
fi

export CMAKE_ENVIRONMENT

### Compiler
if [[ "${AC_VARIANT}" == "gcc" ]]; then

    # gcc
    (
        VERSION="15.2.0"

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
    )

    CC="gcc"
    CXX="g++"
else

    # clang
    (
        VERSION="20.1.8"

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
    )

    { # generate 'slack' bits/stdc++.h
        sudo mkdir -p "${AC_INSTALL_DIR}/include/bits"

        find "${AC_INSTALL_DIR}/include/c++/v1" -maxdepth 1 -type f ! -iname '__**' ! -iname '**.**' -exec echo '#include <{}>' \; |
            sudo tee "${AC_INSTALL_DIR}/include/bits/stdc++.h"
    }

    CC="clang"
    CXX="clang++"
fi

sudo chmod +x -R "${AC_INSTALL_DIR}"

"${CXX}" --version
"${CXX}" -print-search-dirs

CMAKE_ENVIRONMENT+=(
    -DCMAKE_C_COMPILER:STRING="${CC}"
    -DCMAKE_CXX_COMPILER:STRING="${CXX}"
)

if [[ -v CCACHE_ENABLED ]]; then
    BOOST_BUILDER_CONFIG="using ${AC_VARIANT} : : ccache ${CXX} ;"
else
    BOOST_BUILDER_CONFIG="using ${AC_VARIANT} : : ${CXX} ;"
fi

export CMAKE_ENVIRONMENT
export BOOST_BUILDER_CONFIG

### Libraries

# abseil
(
    VERSION="20250512.1"

    set -eu
    if [[ "${AC_NO_BUILD_abseil:-false}" == true && "${AC_NO_BUILD_or_tools:-false}" == true ]]; then exit 0; fi

    cd "${AC_TEMP_DIR}"

    echo "::group::abseil"

    sudo mkdir -p ./abseil

    sudo wget -q "https://github.com/abseil/abseil-cpp/releases/download/${VERSION}/abseil-cpp-${VERSION}.tar.gz" -O ./abseil.tar.gz
    sudo tar -I pigz -xf ./abseil.tar.gz -C ./abseil --strip-components 1

    cd ./abseil

    sudo mkdir -p ./build && cd ./build

    CMAKE_ARGUMENTS=(
        "${CMAKE_ENVIRONMENT[@]}"
        -DABSL_ENABLE_INSTALL:BOOL=ON
        -DABSL_PROPAGATE_CXX_STD:BOOL=ON
        -DABSL_USE_SYSTEM_INCLUDES:BOOL=ON
        -DCMAKE_INSTALL_PREFIX:PATH="${AC_INSTALL_DIR}"
        -DCMAKE_CXX_FLAGS:STRING="-fPIC ${INTERNALL_BUILD_FLAGS[*]}"
    )

    if [[ -v AC_RUN_TEST ]] && [[ "${AC_RUN_TEST}" = "true" ]]; then
        sudo cmake -DABSL_BUILD_TESTING=ON -DABSL_USE_GOOGLETEST_HEAD=ON "${CMAKE_ARGUMENTS[@]}" ..

        sudo make "-j${PARALLEL}"
        sudo ctest --parallel "${PARALLEL}"
    else
        sudo cmake "${CMAKE_ARGUMENTS[@]}" ..
    fi

    sudo cmake --build . --target install

    echo "::endgroup::"
)

# ac-library
(
    VERSION="1.6"

    set -eu
    if "${AC_NO_BUILD_ac_library:-false}"; then exit 0; fi

    cd "${AC_TEMP_DIR}"

    echo "::group::AC Library"

    sudo mkdir -p ./ac-library

    sudo wget -q "https://github.com/atcoder/ac-library/archive/refs/tags/v${VERSION}.tar.gz" -O ./ac-library.tar.gz
    sudo tar -I pigz -xf ./ac-library.tar.gz -C ./ac-library --strip-components 1

    sudo cp -rf ./ac-library/atcoder "${AC_INSTALL_DIR}/include"

    echo "::endgroup::"
)

# boost
(
    VERSION="1.88.0"

    set -eu
    if "${AC_NO_BUILD_boost:-false}"; then exit 0; fi

    cd "${AC_TEMP_DIR}"

    echo "::group::boost"

    sudo mkdir -p ./boost

    sudo wget -q "https://archives.boost.io/release/${VERSION}/source/boost_${VERSION//./_}.tar.bz2" -O ./boost.tar.bz2
    sudo tar -I pbzip2 -xf ./boost.tar.bz2 -C ./boost --strip-components 1

    cd ./boost

    if [[ -v BOOST_BUILDER_CONFIG ]]; then
        echo "${BOOST_BUILDER_CONFIG}" | sudo tee -a ./user-config.jam
    else
        sudo touch ./user-config.jam
    fi

    if [[ -v CCACHE_ENABLED ]]; then
        sudo sed -i \
            -e 's/test_compiler g++$TOOLSET_SUFFIX/test_compiler "ccache g++$TOOLSET_SUFFIX"/g' \
            -e 's/test_compiler clang++$TOOLSET_SUFFIX/test_compiler "ccache clang++$TOOLSET_SUFFIX"/g' \
            ./tools/build/src/engine/build.sh
    fi

    if [[ "${AC_VARIANT}" == "clang" ]]; then
        BOOST_BUILD_FLAGS=("${INTERNALL_BUILD_FLAGS[@]}" "--target=x86_64-unknown-linux-gnu")
    fi

    sudo ./bootstrap.sh \
        --with-toolset="${AC_VARIANT}" \
        --without-libraries=mpi,graph_parallel,python \
        --prefix="${AC_INSTALL_DIR}"

    sudo ./b2 \
        toolset="${AC_VARIANT}" \
        link=static \
        threading=single \
        variant=release \
        cflags="-w" \
        cxxflags="${BOOST_BUILD_FLAGS[*]}" \
        --user-config="./user-config.jam" \
        -j"${PARALLEL}" -d0 \
        install

    echo "::endgroup::"
)

# eigen
(
    VERSION="3.4.0-4"

    set -xeu
    if [[ "${AC_NO_BUILD_eigen:-false}" == true && \
        "${AC_NO_BUILD_light_gbm:-false}" == true && \
        "${AC_NO_BUILD_or_tools:-false}" == true ]]; then
        exit 0
    fi

    echo "::group::Eigen3"

    sudo apt-get install -y "libeigen3-dev=${VERSION}"

    sudo mkdir -p "${AC_INSTALL_DIR}/cmake"

    sudo cp -Trf /usr/include/eigen3 "${AC_INSTALL_DIR}/include"

    # copy and patch cmake files to build OR-Tools.
    sudo cp -f \
        /usr/share/eigen3/cmake/Eigen3Targets.cmake \
        /usr/share/eigen3/cmake/Eigen3Config.cmake \
        "${AC_INSTALL_DIR}/cmake"

    CMAKE_PATH="${AC_INSTALL_DIR}/include"
    CMAKE_PATH="${CMAKE_PATH//'/opt/'/}"

    sudo sed -i \
        -e "s/include\/eigen3/${CMAKE_PATH//'/'/'\/'}/g" \
        "${AC_INSTALL_DIR}/cmake/Eigen3Targets.cmake"

    sudo apt-get remove -y libeigen3-dev

    echo "::endgroup::"
)

# gmp
(
    VERSION="2:6.3.0+dfsg-2ubuntu6.1"

    set -eu
    if "${AC_NO_BUILD_gmp:-false}"; then exit 0; fi

    echo "::group::gmp"

    sudo apt-get install -y "libgmp3-dev=${VERSION}"

    echo "::endgroup::"
)

# immer
(
    VERSION="0.8.1"

    set -eu
    if "${AC_NO_BUILD_immer:-false}"; then exit 0; fi

    cd "${AC_TEMP_DIR}"

    echo "::group::immer"

    sudo mkdir -p ./immer

    sudo wget -q "https://github.com/arximboldi/immer/archive/refs/tags/v${VERSION}.tar.gz" -O ./immer.tar.gz
    sudo tar -I pigz -xf ./immer.tar.gz -C ./immer --strip-components 1

    cd ./immer

    sudo cp -Trf ./immer "${AC_INSTALL_DIR}/include/immer"

    echo "::endgroup::"
)

# libtorch
(
    VERSION=null

    set -eu
    if [[ "${AC_NO_BUILD_libtorch:-false}" == true || "${AC_VARIANT:-}" == "clang" ]]; then
        exit 0
    fi

    cd "${AC_TEMP_DIR}"

    echo "::group::LibTorch"

    sudo wget "https://download.pytorch.org/libtorch/cpu/libtorch-shared-with-deps-${VERSION}%2Bcpu.zip" -O ./libtorch.zip
    sudo unzip -o ./libtorch.zip -d .

    # remove protobuf, which or-tools has as its dependencies.
    sudo rm -f ./libtorch/lib/libprotobuf.a
    sudo rm -f ./libtorch/lib/libprotobuf-lite.a
    sudo rm -f ./libtorch/lib/libprotoc.a

    sudo cp -Trf ./libtorch/include "${AC_INSTALL_DIR}/include"
    sudo cp -Trf ./libtorch/lib "${AC_INSTALL_DIR}/lib"

    echo "::endgroup::"
)

# light-gbm
(
    VERSION="4.6.0"

    set -eu
    if [[ "${AC_NO_BUILD_light_gbm:-false}" == true ]]; then exit 0; fi

    cd "${AC_TEMP_DIR}"

    echo "::group::LightGBM"

    if [ -d ./light-gbm/ ]; then sudo rm -rf ./light-gbm/; fi

    sudo mkdir -p ./light-gbm

    sudo wget -q "https://github.com/microsoft/LightGBM/releases/download/v${VERSION}/lightgbm-${VERSION}.tar.gz" -O ./light-gbm.tar.gz
    sudo tar -I pigz -xf ./light-gbm.tar.gz -C ./light-gbm/ --strip-components 1

    cd ./light-gbm

    sudo rm -rf ./lightgbm
    sudo rm -rf ./external_libs/eigen

    sudo mkdir -p ./build && cd ./build

    sudo cmake "${CMAKE_ENVIRONMENT[@]}" \
        -DBUILD_CLI:BOOL=OFF \
        -DBUILD_STATIC_LIB=ON \
        -DUSE_HOMEBREW_FALLBACK=OFF \
        -DCMAKE_INSTALL_PREFIX:PATH="${AC_INSTALL_DIR}" \
        -DCMAKE_CXX_FLAGS:STRING="${INTERNALL_BUILD_FLAGS[*]} -I${AC_INSTALL_DIR}/include -fopenmp" \
        ..

    sudo cmake --build . --target install

    echo "::endgroup::"
)

# or-tools
(
    VERSION="9.14"

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
        -DBUILD_BZip2:BOOL=ON -DBUILD_ZLIB:BOOL=ON -DBUILD_Protobuf:BOOL=ON -DBUILD_re2:BOOL=ON \
        -DUSE_COINOR:BOOL=ON -DBUILD_CoinUtils:BOOL=ON -DBUILD_Osi:BOOL=ON -DBUILD_Clp:BOOL=ON -DBUILD_Cgl:BOOL=ON -DBUILD_Cbc:BOOL=ON \
        -DUSE_GLPK:BOOL=ON -DBUILD_GLPK:BOOL=ON \
        -DUSE_HIGHS:BOOL=ON -DBUILD_HIGHS:BOOL=ON \
        -DUSE_SCIP:BOOL=ON -DBUILD_SCIP:BOOL=ON -DBUILD_soplex:BOOL=ON -DBUILD_Boost:BOOL=ON \
        -DBUILD_SAMPLES:BOOL=OFF -DBUILD_EXAMPLES:BOOL=OFF \
        -DBUILD_TESTING:BOOL="${BUILD_TESTING}" \
        -DCMAKE_PREFIX_PATH:PATH="${AC_INSTALL_DIR}" \
        -DCMAKE_INSTALL_PREFIX:PATH="${AC_INSTALL_DIR}" \
        -DBUILD_SHARED_LIBS:BOOL=OFF \
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
        -DCMAKE_CXX_FLAGS:STRING="${INTERNALL_BUILD_FLAGS[*]}" \
        ..

    sudo cmake --build . --config Release --target install

    if [[ -v AC_RUN_TEST ]] && [[ "${AC_RUN_TEST}" = "true" ]]; then
        sudo cmake --build . --config Release --target test --parallel "${PARALLEL}"
    fi

    echo "::endgroup::"
)

# range-v3
(
    VERSION="0.12.0"

    set -eu
    if "${AC_NO_BUILD_range_v3:-false}"; then exit 0; fi

    cd "${AC_TEMP_DIR}"

    echo "::group::range-v3"

    sudo mkdir -p ./range-v3

    sudo wget -q "https://github.com/ericniebler/range-v3/archive/refs/tags/${VERSION}.tar.gz" -O ./range-v3.tar.gz
    sudo tar -I pigz -xf ./range-v3.tar.gz -C ./range-v3 --strip-components 1

    sudo cp -Trf ./range-v3/include "${AC_INSTALL_DIR}/include"

    echo "::endgroup::"
)

# unordered_dense
(
    VERSION="4.5.0"

    set -eu
    if "${AC_NO_BUILD_unordered_dense:-false}"; then exit 0; fi

    cd "${AC_TEMP_DIR}"

    echo "::group::unordered_dense"

    sudo mkdir -p ./unordered_dense

    sudo wget "https://github.com/martinus/unordered_dense/archive/refs/tags/v${VERSION}.tar.gz" -O ./unordered_dense.tar.gz
    sudo tar -I pigz -xf ./unordered_dense.tar.gz -C ./unordered_dense --strip-components 1

    cd ./unordered_dense

    sudo mkdir -p ./build && cd ./build

    sudo cmake "${CMAKE_ENVIRONMENT[@]}" \
        -DCMAKE_INSTALL_PREFIX:PATH="${AC_INSTALL_DIR}" \
        ..

    sudo cmake --build . --target install

    echo "::endgroup::"
)

# z3
(
    VERSION="4.15.2"

    set -eu
    if "${AC_NO_BUILD_z3:-false}"; then exit 0; fi

    cd "${AC_TEMP_DIR}"

    echo "::group::Z3"

    sudo mkdir -p ./z3

    sudo wget -q "https://github.com/Z3Prover/z3/archive/refs/tags/z3-${VERSION}.tar.gz" -O ./z3.tar.gz
    sudo tar -I pigz -xf ./z3.tar.gz -C ./z3 --strip-components 1

    cd ./z3

    sudo mkdir -p ./build && cd ./build

    sudo cmake "${CMAKE_ENVIRONMENT[@]}" \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -DCMAKE_INSTALL_PREFIX:PATH="${AC_INSTALL_DIR}" \
        -DCMAKE_CXX_FLAGS:STRING="${INTERNALL_BUILD_FLAGS[*]}" \
        ..

    sudo cmake --build . --target install

    echo "::endgroup::"
)

if ! ${AC_NO_GENERATE_CACHES:-false}; then
    echo ::group::generate caches

    if [[ "${AC_VARIANT}" == "gcc" ]]; then
        # Generate caches of std and std.compat modules.
        "${CXX}" bits/std.cc bits/std.compat.cc "${PRECOMPILE_BUILD_FLAGS[@]}" -c -fmodule-only -fsearch-include-path
    else
        "${CXX}" "${AC_INSTALL_DIR}/share/libc++/v1/std.cppm" -o std.pcm -Wno-reserved-module-identifier --precompile "${PRECOMPILE_BUILD_FLAGS[@]}"
        "${CXX}" "${AC_INSTALL_DIR}/share/libc++/v1/std.compat.cppm" -o std.compat.pcm -Wno-reserved-module-identifier --precompile "${PRECOMPILE_BUILD_FLAGS[@]}"
    fi

    echo "::endgroup::"
fi

if [ -v ATCODER ]; then
    echo "::group::finalize"

    find "${AC_INSTALL_DIR}" \
        -name cmake -or -name pkgconfig \
        -type d -print0 |
        xargs -0 sudo rm -rf

    sudo apt-get purge -y --auto-remove git cmake lld ninja-build pigz pbzip2

    echo "::endgroup::"
fi
