#!/bin/sh

set -xe

git clone https://github.com/erinmaus/discworld || true
cd discworld
sed -i 's/lua51/luajit-5.1/g' premake5.lua || true
sed -i 's/platforms { "x64" }//g' premake5.lua || true
../premake5/premake5 --DEPS="../installdir" gmake
CPPFLAGS="-I$(pwd)/../installdir/include/luajit-2.1 -ftemplate-depth=2000 -fPIC" make config=release Mapp
cd ..
cp discworld/bin/libMapp.so installdir/lib/lua/5.1/mapp.so
