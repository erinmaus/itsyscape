#!/bin/sh

set -xe

cd build

git clone https://github.com/erinmaus/discworld || true
cd discworld

../../premake5 --deps="$(pwd)/.." --os=ios gmake

export CC="$(xcrun --sdk iphoneos --find clang) -isysroot $(xcrun --sdk iphoneos --show-sdk-path) -arch arm64 -fPIC -miphoneos-version-min=13.0"
export CXX="$(xcrun --sdk iphoneos --find clang++) -isysroot $(xcrun --sdk iphoneos --show-sdk-path) -arch arm64 -fPIC -miphoneos-version-min=13.0"
export LD="$(xcrun --sdk iphoneos --find ld) -isysroot $(xcrun --sdk iphoneos --show-sdk-path)  -arch arm64 -all_load"

make config=release_x64 clean
CFLAGS="-arch arm64 -g3" CPPFLAGS="-I$(pwd)/../LuaJIT/src -DSOL_NO_NIL=0" LDFLAGS="-arch arm64" make config=release_x64

mkdir -p ../../staging/ext
cp ./bin/libMapp.dylib ../../staging/ext/mapp.dylib
