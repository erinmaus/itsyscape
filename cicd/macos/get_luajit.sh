#!/bin/sh

set -xe

cd build
git clone https://github.com/LuaJIT/LuaJIT || true
cd LuaJIT

MACOSX_DEPLOYMENT_TARGET="10.12" make clean
CFLAGS="-DDLUAJIT_ENABLE_LUA52COMPAT" TARGET_FLAGS="-arch x86_64" MACOSX_DEPLOYMENT_TARGET="10.12" make
cp ./src/libluajit.so ./src/libluajit_x64.dylib
install_name_tool -id "@rpath/Lua.framework/Versions/A/Lua" ./src/libluajit_x64.dylib

CFLAGS="-DDLUAJIT_ENABLE_LUA52COMPAT" TARGET_FLAGS="-arch x86_64" MACOSX_DEPLOYMENT_TARGET="11.00" make clean

CFLAGS="-DDLUAJIT_ENABLE_LUA52COMPAT" TARGET_FLAGS="-arch arm64" MACOSX_DEPLOYMENT_TARGET="11.00" make
cp ./src/libluajit.so ./src/libluajit_m1.dylib
install_name_tool -id "@rpath/Lua.framework/Versions/A/Lua" ./src/libluajit_m1.dylib

lipo -create -output ./src/liblua51.dylib ./src/libluajit_x64.dylib ./src/libluajit_m1.dylib

mkdir -p ../lib
cp ./src/liblua51.dylib ../lib
cp ./src/liblua51.dylib ../staging
mkdir -p ../include
cp ./src/lua.h ../include
cp ./src/lualib.h ../include
cp ./src/lauxlib.h ../include
cp ./src/luajit.h ../include
cp ./src/lua.hpp ../include
cp ./src/luaconf.h ../include