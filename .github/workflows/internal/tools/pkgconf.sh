#!/bin/bash
set -eu

# if pkgconf --version; then exit 0; fi

VERSION="2.4.3"

sudo mkdir -p /tmp/ac_tools && cd /tmp/ac_tools

sudo wget https://distfiles.ariadne.space/pkgconf/pkgconf-${VERSION}.tar.xz
sudo tar -xf pkgconf-${VERSION}.tar.xz

cd ./pkgconf-${VERSION}

sudo ./configure --prefix=/usr

sudo make
sudo make install "-j$(nproc)"

sudo pkgconf --version
