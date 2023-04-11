#!/bin/sh

set -xe

cd build

git clone https://github.com/erinmaus/discworld || true
cd discworld

../../premake5 --deps="$(pwd)/.." gmake

make config=release_x64 clean
CFLAGS="-arch x86_64" CPPFLAGS="-I$(pwd)/../LuaJIT/src -DSOL_NO_NIL=0 -arch x86_64" LDFLAGS="-arch x86_64" make config=release_x64
mv ./bin/libMapp.dylib ./bin/libMapp_intel.dylib

make config=release_x64 clean
CFLAGS="-arch arm64" CPPFLAGS="-I$(pwd)/../LuaJIT/src -DSOL_NO_NIL=0 -arch arm64" LDFLAGS="-arch arm64" make config=release_x64
mv ./bin/libMapp.dylib ./bin/libMapp_m1.dylib

lipo -create -output ./bin/libMapp.dylib ./bin/libMapp_intel.dylib ./bin/libMapp_m1.dylib

mkdir -p ../../staging/ext
cp ./bin/libMapp.dylib ../../staging/ext/mapp.dylib
