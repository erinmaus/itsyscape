#!/bin/sh

set -xe

cd build
git clone https://github.com/erinmaus/discworld || true
cd discworld
sed -i 's/platforms { "x64" }//g' premake5.lua || true
../../premake5 --DEPS="$(pwd)/.." gmake
CPPFLAGS="-ftemplate-depth=2000" make config=release Mapp

mkdir -p ../../staging/ext
cp ./bin/Mapp.dll ../../staging/ext/mapp.dll
