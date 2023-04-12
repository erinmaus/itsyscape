#!/bin/sh

set -xe

cp -r ../../utilities ./build/nbunny

cd build/nbunny

sed -i 's/platforms { "x86", "x64", "ARM64" }//g' premake5.lua

../../premake5 --DEPS="$(pwd)/.." gmake

CPPFLAGS="-I$(pwd)/../megasource/libs/love/src/modules -I$(pwd)/../megasource/libs/love/src/modules -I$(pwd)/../megasource/libs/love/src" LDFLAGS="-L$(pwd)/../megasource-build/love -L$(pwd)/../lib -llove -lsentry" make config=release nbunny

cp bin/nbunny.dll ../../staging/ext/nbunny.dll
