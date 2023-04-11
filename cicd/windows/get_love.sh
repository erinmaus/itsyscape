#!/bin/sh

set -xe

cd build
git clone https://github.com/love2d/megasource || true
cd megasource
git checkout .
git apply ../../megasource.patch
cd ..

git clone https://github.com/erinmaus/love2d ./megasource/libs/love || true
rm -rf ./megasource/libs/LuaJIT
git clone https://github.com/LuaJIT/LuaJIT ./megasource/libs/LuaJIT
rm -rf ./megasource/libs/SDL2
git clone -b SDL2 https://github.com/libsdl-org/SDL.git ./megasource/libs/SDL2

cmake -G "MSYS Makefiles" -Bmegasource-build -Hmegasource -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$(pwd)/../staging"
cmake --build megasource-build --target install -j2

cp ./megasource-build/love/liblove.dll ../staging/liblove.dll
cp ./megasource-build/love/lovew.exe ../staging/love.exe
cp ./megasource-build/love/lovec.exe ../staging/lovec.exe
cp ./megasource-build/love/Release/*.dll ../staging
