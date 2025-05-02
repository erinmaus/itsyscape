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
sed -i "s/LOVE_MAJOR.\*/LOVE_MAJOR ${ITSYREALM_MAJOR}/g" ./megasource/libs/love/extra/windows/love.rc.in || true
sed -i "s/LOVE_MINOR.\*/LOVE_MINOR ${ITSYREALM_MINOR}/g" ./megasource/libs/love/extra/windows/love.rc.in || true
sed -i "s/LOVE_REVISION.\*/LOVE_REVISION ${ITSYREALM_MINOR}/g" ./megasource/libs/love/extra/windows/love.rc.in || true
sed -i "s/LOVE_BUILD.\*/LOVE_BUILD ${ITSYREALM_BUILD}/g" ./megasource/libs/love/extra/windows/love.rc.in || true
sed -i "s/LOVE_VERSION_STRING.\*/LOVE_VERSION_STRING \"${ITSYREALM_MAJOR}.${ITSYREALM_MINOR}.${ITSYREALM_REVISION}\""
iconv -f UTF-8 -t UTF16-LE ./megasource/libs/love/extra/windows/love.rc.in > ./megasource/libs/love/extra/windows/love.rc

rm -rf ./megasource/libs/LuaJIT
git clone https://github.com/LuaJIT/LuaJIT ./megasource/libs/LuaJIT
cd ./megasource/libs/LuaJIT && git checkout 224129a8e64bfa219d35cd03055bf03952f167f6 && cd ../../..
rm -rf ./megasource/libs/SDL2
git clone -b SDL2 https://github.com/libsdl-org/SDL.git ./megasource/libs/SDL2

cmake -G "MSYS Makefiles" -Bmegasource-build -Hmegasource -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$(pwd)/../staging"
cmake --build megasource-build --target install -j2

cp ./megasource-build/love/liblove.dll ../staging/liblove.dll
cp ./megasource-build/love/lovew.exe ../staging/love.exe
cp ./megasource-build/love/lovec.exe ../staging/lovec.exe
cp ./megasource-build/love/Release/*.dll ../staging
