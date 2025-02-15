#!/bin/bash
set +u
if [[ ${AC_NO_BUILD_COMPILER} ]]; then exit 0; fi
set -eu

echo "::group::GCC"

sudo apt-get install -y "g++-14=${VERSION}"

echo "::endgroup::"
