#!/bin/sh

set -xe

mkdir -p itsyscape
rm -rf itsyscape/utilities
cp -r ../../utilities itsyscape/

cd itsyscape/utilities
sed -i 's/lua51/luajit-5.1/g' premake5.lua
sed -i 's/platforms { "x86", "x64", "ARM64" }//g' premake5.lua

../../premake5/premake5 --DEPS="../installdir" gmake

CPPFLAGS="-I $(pwd)/../../installdir/include/luajit-2.1 -I $(pwd)/../../love2d-${LOVE_BRANCH}/src -I $(pwd)/../../love2d-${LOVE_BRANCH}/src/modules -I $(pwd)/../../installdir/include -DGLM_ENABLE_EXPERIMENTAL" LDFLAGS="-L$(pwd)/../../installdir/lib -llove -lluajit-5.1 -lsentry" make config=release nbunny
cd ../..
cp itsyscape/utilities/bin/libnbunny.so installdir/lib/lua/5.1/nbunny.so
