#!/bin/sh

set -xe

cd build

git clone https://github.com/erinmaus/devi
cd devi

make PREFIX=$(pwd)/.. LUA_LIB=lua51 all

mkdir -p ../../staging/ext
cp build/devi.dylib ../../staging/ext/devi.dylib
cp -r devi ../../staging/ext/
