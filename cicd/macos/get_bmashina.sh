#!/bin/sh

set -xe

cd build

git clone https://github.com/erinmaus/bmashina || true
cd bmashina

../../premake5 --deps="$(pwd)/.." gmake

make config=release_arm64 clean
CPPFLAGS="-I$(pwd)/../LuaJIT/src -DSOL_NO_NIL=0 -stdlib=libc++ -arch x86_64" LDFLAGS="-arch x86_64" make config=release_arm64
file ./bin/libbmashina.dylib
mv ./bin/libbmashina.dylib ./bin/libbmashina_intel.dylib

make config=release_arm64 clean
CPPFLAGS="-I$(pwd)/../LuaJIT/src -DSOL_NO_NIL=0 -stdlib=libc++ -arch arm64" LDFLAGS="-arch arm64" make config=release_arm64
mv ./bin/libbmashina.dylib ./bin/libbmashina_m1.dylib

lipo -create -output ./bin/libbmashina.dylib ./bin/libbmashina_intel.dylib ./bin/libbmashina_m1.dylib

mkdir -p ../../staging/ext
cp -r ./lmashina/lua/B ../../staging/ext
cp ./bin/libbmashina.dylib ../../staging/ext/bmashina.dylib
