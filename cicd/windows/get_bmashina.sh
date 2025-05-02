#!/bin/sh

set -xe

cd build
git clone https://github.com/erinmaus/bmashina || true
cd bmashina
sed -i 's/platforms { "x64" }//g' premake5.lua
../../premake5 --DEPS="$(pwd)/.." gmake
CPPFLAGS="-I$(pwd)/../LuaJIT/src" make config=release

mkdir -p ../../staging/ext
cp -r ./lmashina/lua/B ../../staging/ext
cp ./bin/bmashina.dll ../../staging/ext/bmashina.dll