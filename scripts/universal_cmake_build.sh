#!/bin/bash

source /home/$USER/.local/bin/functions.sh

BUILD_DIR_NAME="cmake-build"
BUILD_DIR_LOCATION="../${BUILD_DIR_NAME}"
CMAKE_ARGS="-DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_VERBOSE_MAKEFILE=ON"

universal_cmake_build $BUILD_DIR_LOCATION $CMAKE_ARGS #"-DSG_USE_CLANG_TIDY=ON"
