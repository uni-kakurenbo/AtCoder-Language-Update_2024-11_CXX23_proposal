#!/bin/bash
set -xeu
if [[ "${AC_NO_BUILD_eigen:-false}" == true &&
    "${AC_NO_BUILD_light_gbm:-false}" == true &&
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
