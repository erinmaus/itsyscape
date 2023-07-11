#!/bin/sh

set -xe

cd build
git clone https://github.com/LuaJIT/LuaJIT || true
cd LuaJIT
git checkout 224129a8e64bfa219d35cd03055bf03952f167f6
make

mkdir -p ../lib
cp ./src/lua51.dll ../lib
cp ./src/lua51.dll ../../staging/lua51.dll
mkdir -p ../include
cp ./src/lua.h ../include
cp ./src/lualib.h ../include
cp ./src/lauxlib.h ../include
cp ./src/luajit.h ../include
cp ./src/lua.hpp ../include
cp ./src/luaconf.h ../include