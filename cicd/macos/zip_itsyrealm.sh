#!/bin/sh

set -xe

cd ../../itsyscape

pushd ..
make LUAJIT="$(pwd)/cicd/macos/build/LuaJIT/src/luajit" all
popd

echo $ITSYREALM_VERSION > version.meta

cp -r ../cicd/macos/staging/ext/B ./B
cp -r ../cicd/macos/staging/ext/devi ./devi
cp -r ../cicd/macos/staging/ext/nomicon ./nomicon

export LUA_CPATH="$(pwd)/../cicd/macos/staging/ItsyRealm.app/Contents/Frameworks/?.dylib;$(pwd)/../cicd/macos/staging/ItsyRealm.app/Contents/Frameworks/?.so"
../cicd/macos/staging/ItsyRealm.app/Contents/MacOS/ItsyRealm --fused . --f:anonymous --main ItsyScape.BuildLargeTileSetsApplication
cp -rv ~/Library/Application\ Support/ItsyRealm/Resources/* Resources/
LUAJIT="$(pwd)/cicd/macos/build/LuaJIT/src/luajit" ../build.sh

zip -9 -qr ../cicd/macos/staging/ItsyRealm.app/Contents/Resources/itsyrealm.love .
rm -r ./B
rm -r ./devi
rm -r ./nomicon
