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
rm -f ../cicd/macos/staging/ItsyRealm.app/Contents/Resources/itsyrealm.love && find . -type f | sort | tr "\n" "\0" | xargs -0 -n1 zip -0 ../cicd/macos/staging/ItsyRealm.app/Contents/Resources/itsyrealm.love
rm -r ./B
rm -r ./devi
rm -r ./nomicon
