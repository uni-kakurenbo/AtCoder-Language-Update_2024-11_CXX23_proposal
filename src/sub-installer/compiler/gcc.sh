#!/bin/bash
set -eu

echo "::group::GCC"

sudo apt-get install -y "g++-14=${VERSION}"

echo "::endgroup::"
