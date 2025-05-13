#!/bin/bash
set -eu

ARGUMENTS=("$0")
while (($# > 0)); do
    case "$1" in
    --variant)
        AC_VARIANT="$2"
        shift
        ;;
    -h | --help | ?)
        echo "{--option}       / {ENVIRONMENT}      [default]"
        echo "--variant        / AC_VARIANT         [gcc]"
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

if [[ -z "${AC_VARIANT}" ]]; then
    export AC_VARIANT="gcc"
fi

INSTALL_DIR="$(cat /etc/atcoder/install_dir.txt)"

# shellcheck disable=SC2016
USER_BUILD_FLAGS=("${USER_BUILD_FLAGS[@]//'::install_dir::'/${INSTALL_DIR}}")

if [[ "${AC_VARIANT}" = "gcc" ]]; then
    g++ ./Main.cpp -o a.out "${USER_BUILD_FLAGS[@]}"
else
    clang++ std.pcm std.compat.pcm ./Main.cpp -o a.out "${USER_BUILD_FLAGS[@]}"
fi
