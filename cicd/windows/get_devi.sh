#!/bin/sh

set -xe

cd build

git clone https://github.com/erinmaus/devi
cd devi

make PREFIX=$(pwd)/.. LUA_LIB=:lua51.dll all

mkdir -p ../../staging/ext
cp build/devi.dll ../../staging/ext/devi.dll
cp -r devi ../../staging/ext/
