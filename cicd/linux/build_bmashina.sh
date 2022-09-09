#!/bin/bash

set -xe

git clone https://github.com/bkdoormaus/bmashina || cd bmashina && git pull && cd ..
cd bmashina
sed -i 's/lua51/luajit-5.1/g' premake5.lua
sed -i 's/platforms { "x64" }//g' premake5.lua
../premake5/premake5 --DEPS="../installdir" gmake
echo "$(pwd)/include/luajit-2.1"
CPPFLAGS="-I $(pwd)/../installdir/include/luajit-2.1" make config=release
cd ..
cp bmashina/bin/libbmashina.so installdir/lib/lua/5.1/bmashina.so
