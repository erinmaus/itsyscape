#!/bin/sh

set -xe

cd build
git clone https://github.com/LuaJIT/LuaJIT || true
cd LuaJIT

ISDKP=$(xcrun --sdk iphoneos --show-sdk-path)
ICC=$(xcrun --sdk iphoneos --find clang)
ISDKF="-arch arm64 -isysroot $ISDKP"
make DEFAULT_CC=clang CROSS="$(dirname $ICC)/" \
     TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS

mkdir -p ../lib
cp ./src/libluajit.a ../lib/liblua51.a
mkdir -p ../include
cp ./src/lua.h ../include
cp ./src/lualib.h ../include
cp ./src/lauxlib.h ../include
cp ./src/luajit.h ../include
cp ./src/lua.hpp ../include
cp ./src/luaconf.h ../include

rm -rf ../lib/Lua.xcframework
xcodebuild -create-xcframework -library ../lib/liblua51.a -headers ../include -output ../lib/Lua.xcframework
