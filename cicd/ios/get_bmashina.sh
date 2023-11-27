#!/bin/sh

set -xe

cd build

git clone https://github.com/erinmaus/bmashina || true
cd bmashina

export CC="$(xcrun --sdk iphoneos --find clang) -isysroot $(xcrun --sdk iphoneos --show-sdk-path) -arch arm64 -fPIC -miphoneos-version-min=13.0"
export CXX="$(xcrun --sdk iphoneos --find clang++) -isysroot $(xcrun --sdk iphoneos --show-sdk-path) -arch arm64 -fPIC -miphoneos-version-min=13.0"
export LD="$(xcrun --sdk iphoneos --find ld) -isysroot $(xcrun --sdk iphoneos --show-sdk-path)  -arch arm64 -all_load"

../../premake5 --deps="$(pwd)/.." --os=ios gmake

CFLAGS="-I$(pwd)/../LuaJIT/src -DSOL_NO_NIL=0 -stdlib=libc++ -arch arm64" LDFLAGS="-arch arm64" make config=release_arm64

mkdir -p ../../staging/ext
cp -r ./lmashina/lua/B ../../staging/ext
cp ./bin/libbmashina.dylib ../../staging/ext/bmashina.dylib
