#!/bin/sh

set -xe

cd build
git clone https://github.com/love2d/megasource || true
cd megasource
git checkout . && git checkout 11.x
git apply ../../megasource.patch
cd ..

git clone https://github.com/erinmaus/love2d ./megasource/libs/love || true
cp ../love.rc ./megasource/libs/love/extra/windows/love.rc.in

source ../../common/make_version.sh env
sed -i "s/^#define.*LOVE_MAJOR.*$/#define LOVE_MAJOR ${ITSYREALM_MAJOR:-0}/g" ./megasource/libs/love/extra/windows/love.rc.in || true
sed -i "s/^#define.*LOVE_MINOR.*$/#define LOVE_MINOR ${ITSYREALM_MINOR:-0}/g" ./megasource/libs/love/extra/windows/love.rc.in || true
sed -i "s/#define.*LOVE_REVISION.*$/#define LOVE_REVISION ${ITSYREALM_REVISION:-0}/g" ./megasource/libs/love/extra/windows/love.rc.in || true
sed -i "s/#define.*LOVE_BUILD.*$/#define LOVE_BUILD ${ITSYREALM_BUILD:-0}/g" ./megasource/libs/love/extra/windows/love.rc.in || true
sed -i "s/^#define.*LOVE_VERSION_STRING.*$/#define LOVE_VERSION_STRING \\\"${ITSYREALM_MAJOR:-0}.${ITSYREALM_MINOR:-0}.${ITSYREALM_REVISION:-0}\\\"/g" ./megasource/libs/love/extra/windows/love.rc.in || true
cp ./megasource/libs/love/extra/windows/love.rc.in ./megasource/libs/love/extra/windows/love.rc

rm -rf ./megasource/libs/LuaJIT
git clone https://github.com/LuaJIT/LuaJIT ./megasource/libs/LuaJIT
cd ./megasource/libs/LuaJIT && git checkout 224129a8e64bfa219d35cd03055bf03952f167f6 && cd ../../..
rm -rf ./megasource/libs/SDL2
git clone -b SDL2 https://github.com/libsdl-org/SDL.git ./megasource/libs/SDL2

RCFLAGS="--codepage=65001" cmake -G "MSYS Makefiles" -Bmegasource-build -Hmegasource -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$(pwd)/../staging"
cmake --build megasource-build --target install -j2

cp ./megasource-build/love/liblove.dll ../staging/liblove.dll
cp ./megasource-build/love/lovew.exe ../staging/love.exe
cp ./megasource-build/love/lovec.exe ../staging/lovec.exe
cp ./megasource-build/love/Release/*.dll ../staging
