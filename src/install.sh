#!/bin/bash
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
    ./sub-installer/compiler/gcc.sh

    CC="gcc"
    CXX="g++"
else
    ./sub-installer/compiler/clang.sh

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
./sub-installer/library/abseil.sh
./sub-installer/library/ac-library.sh
./sub-installer/library/boost.sh
./sub-installer/library/eigen.sh
./sub-installer/library/gmp.sh
./sub-installer/library/immer.sh
./sub-installer/library/libtorch.sh
./sub-installer/library/light-gbm.sh
./sub-installer/library/or-tools.sh
./sub-installer/library/range-v3.sh
./sub-installer/library/unordered_dense.sh
./sub-installer/library/z3.sh

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
