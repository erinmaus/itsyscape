#!/bin/sh

set -xe

rm -rf ./staging/itsyrealm
cp -r ../../itsyscape ./staging/itsyrealm
cp -r ./staging/ext/B ./staging/itsyrealm/B
cp -r ./staging/ext/devi ./staging/itsyrealm/devi
cp -r ./staging/ext/nomicon ./staging/itsyrealm/nomicon
cp -r ./staging/ext/slick ./staging/itsyrealm/slick

LOVE_BINARY="$(pwd)/itsyrealm/ItsyRealm.app/Contents/MacOS/ItsyRealm"
"$LOVE_BINARY" --fused --f:anonymous --debug --main ItsyScape.BuildLargeTileSetsApplication

cp -vr "$HOME/Library/Application Support/ItsyRealm/Resources/"* ./staging/itsyrealm/Resources

cd ./staging/itsyrealm
LUAJIT="$(pwd)/../../build/LuaJIT/src/luajit" ../../../common/make_bin.sh
cd ../..

cd ./staging/itsyrealm
zip -0 -oXqr ../itsyrealm.love .
