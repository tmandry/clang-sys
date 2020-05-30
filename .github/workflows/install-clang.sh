#!/bin/bash

set -e

DIRECTORY="~/clang"

OS=$1
CLANG=$2

function export_clang() {
    export LD_LIBRARY_PATH="${LLVM_DIRECTORY}/lib":$LD_LIBRARY_PATH
    export DYLD_LIBRARY_PATH="${LLVM_DIRECTORY}/lib":$DYLD_LIBRARY_PATH
    export LLVM_CONFIG_PATH="$DIRECTORY/bin/llvm-config"
    $LLVM_CONFIG_PATH --version
}

if [ -d "$DIRECTORY" ]; then
    echo "Using cached Clang."
    export_clang
    exit 0
fi

if [ "$OS" == "ubuntu-latest" ] && [ "$CLANG" == "clang_3_5" ]; then
    URL="https://releases.llvm.org/3.5.2/clang+llvm-3.5.2-x86_64-linux-gnu-ubuntu-14.04.tar.xz"
elif [ "$OS" == "macos-latest" ]&& [ "$CLANG" == "clang_3_5" ]; then
    URL="https://releases.llvm.org/3.5.2/clang+llvm-3.5.2-x86_64-apple-darwin.tar.xz"
elif [ "$OS" == "ubuntu-latest" ] && [ "$CLANG" == "clang_9_0" ]; then
    URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/clang+llvm-9.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz"
elif [ "$OS" == "macos-latest" ]&& [ "$CLANG" == "clang_9_0" ]; then
    URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/clang+llvm-9.0.1-x86_64-apple-darwin.tar.xz"
else
    echo "Unsupported operating system and Clang version combination: $OS + $CLANG"
    exit 1
fi

wget --no-verbose -O ./llvm.tar.xz $URL
mkdir -p $DIRECTORY
tar xf ./llvm.tar.xz -C $DIRECTORY --strip-components=1
export_clang
