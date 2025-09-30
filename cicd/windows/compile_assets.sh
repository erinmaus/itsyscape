#!/bin/sh

set -xe

cd build

mkdir -p assets
cd assets

pushd ../../../..
pwd
./cicd/common/make_bin.sh
make clean || true
make all LUAJIT=./cicd/windows/build/LuaJIT/src/luajit 
popd

rm -rf itsyscape
cp -r ../../../../itsyscape itsyscape
