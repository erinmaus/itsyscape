#!/bin/sh

set -xe

git clone https://github.com/erinmaus/devi
cd devi

make PREFIX=$(pwd)/../installdir DEVI_CXXFLAGS="-I$(pwd)/../installdir/include/luajit-2.1" LUA_LIB=luajit-5.1 all

cp build/devi.so ../installdir/lib/lua/5.1/devi.so
