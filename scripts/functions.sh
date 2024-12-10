#!/bin/bash

function gitBranchName() {
    ROOT_DIR=$1
    cd $ROOT_DIR

    PROJECT_SOURCE_BRANCH=$(git rev-parse --abbrev-ref HEAD)

    PROJECT_TASK=$(echo "$PROJECT_SOURCE_BRANCH" | grep -oE '\-[0-9]+' | head -1)
    PROJECT_RELEASE_NAME=$PROJECT_RELEASE_NAME$PROJECT_TASK

    if [ -z "$PROJECT_RELEASE_NAME" ]; then 
	PROJECT_RELEASE_NAME="-"$PROJECT_SOURCE_BRANCH
    fi

    if [[ $PROJECT_RELEASE_NAME == *"/"* ]]; then
      PROJECT_RELEASE_NAME="${PROJECT_RELEASE_NAME//\//-}"
    fi

    echo $PROJECT_RELEASE_NAME
}

function changePathToCompileCommandFile() {
    PROJECT_RELEASE_NAME=$1
    PROJECT_PATH_BUILD=$2
    NVIMCONFIG=~/.config/nvim/init.lua

    #PROJECT_RELEASE_NAME=$(gitBranchName $ROOT_DIR)

    searchStringNvim="cmd ="
    templateNvim="cmd = {'clangd', '-compile-commands-dir=$PROJECT_PATH_BUILD/local-builds/local-build'"

    if rg "$searchStringNvim" "$NVIMCONFIG"; then
      sed -i "s|$searchStringNvim.*|${templateNvim%?}$PROJECT_RELEASE_NAME\'\}\,|g" "$NVIMCONFIG"
    else
      echo "nvim path failed to change"
      exit 1
    fi
}

function err_han() {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "Command exited with an error (exit code: $status)" 
        exit $status
    fi
}

function check_root_dir() {
    if [ 1 != "$#" ]; then
        echo "Function 'check_root_dir' require 1 arg"
        exit 1
    fi

    local ROOT_DIR=$1

    if [[ $(basename $PWD) != "$ROOT_DIR" ]]; then 
            echo "root dir must be $ROOT_DIR"
            exit 1
    fi
}

function universal_cmake_build() {
    BUILD_DIR_LOCATION=$1
    OTHER_ARGUMENTS=$2

    if [ ! -f "CMakeLists.txt" ]; then
        echo "The file CMakeLists.txt does not exist in the directory"
        exit -1
    fi

    if [ -d $BUILD_DIR_LOCATION ]; then
        echo "BUILD DIRECTORY EXIST"
    else
        mkdir -p $BUILD_DIR_LOCATION
    fi

    err_han cmake $OTHER_ARGUMENTS -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -S . -B $BUILD_DIR_LOCATION
    if [ -f "${BUILD_DIR_LOCATION}/compile_commands.json" ]; then
        rm compile_commands.json
    fi

    ln -s $BUILD_DIR_LOCATION/compile_commands.json . && cmake --build $BUILD_DIR_LOCATION -j$(nproc)
}
