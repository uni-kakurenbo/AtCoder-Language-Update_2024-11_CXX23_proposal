#!/bin/bash
set -eu

### GCC
sudo apt-get install -y "g++-14=${VERSION}"

### Libraries
sudo apt-get install -y cmake pigz pbzip2

./sub-installers/abseil.sh
./sub-installers/AC-Library.sh
./sub-installers/Boost.sh
./sub-installers/Eigen.sh
./sub-installers/GMP.sh
./sub-installers/libtorch.sh
./sub-installers/LightGBM.sh
./sub-installers/range-v3.sh
./sub-installers/unordered_dense.sh

sudo apt-get remove -y --auto-remove cmake pigz pbzip2
