#!/bin/sh

set -xe

cd build

git clone https://github.com/erinmaus/devi || true
cd devi

make PLATFORM=IOS PREFIX=$(pwd)/.. LUA_LIB=lua51 all

mkdir -p ../../staging/ext
cp -r devi ../../staging/ext
cp build/devi.dylib ../../staging/ext/devi.dylib
