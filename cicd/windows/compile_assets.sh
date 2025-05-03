#!/bin/sh

set -xe

cd build

mkdir -p assets
cd assets

pushd ../../../..
pwd
make clean || true
make all LUAJIT=./cicd/windows/build/LuaJIT/src/luajit 
LUAJIT=./cicd/windows/build/LuaJIT/src/luajit ./build.sh
popd

rm -rf itsyscape
cp -r ../../../../itsyscape itsyscape

LUA_CPATH="../../staging/ext/?.dll" LUA_PATH="../../staging/ext/?.lua;../../staging/ext/?/init.lua" ../../staging/lovec.exe --fused itsyscape --f:anonymous --debug --main ItsyScape.BuildLargeTileSetsApplication

cp -r `cygpath -m $APPDATA`/ItsyRealm/Resources/* ./itsyscape/Resources
