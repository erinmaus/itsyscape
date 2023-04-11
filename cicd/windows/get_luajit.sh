#!/bin/sh

set -xe

cd build
git clone https://github.com/LuaJIT/LuaJIT || true
cd LuaJIT
make

mkdir -p ../lib
cp ./src/lua51.dll ../lib
cp ./src/lua51.dll ../staging
mkdir -p ../include
cp ./src/lua.h ../include
cp ./src/lualib.h ../include
cp ./src/lauxlib.h ../include
cp ./src/luajit.h ../include
cp ./src/lua.hpp ../include
cp ./src/luaconf.h ../include