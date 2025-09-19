#!/bin/bash

set -xe

rm -rf itsyscape-love

pushd ../..
make clean || true
make LUAJIT="$(pwd)/cicd/linux/installdir/bin/luajit" all
popd

cp -r ../../itsyscape itsyscape-love
cd itsyscape-love

cp -r ../bmashina/lmashina/lua/B ./B
cp -r ../devi/devi ./devi
cp -r ../nomicon/nomicon ./nomicon
cp -r ../slick/slick ./slick

export LD_LIBRARY_PATH="$(pwd)/../installdir/lib/:$LD_LIBRARY_PATH"
export PATH="$(pwd)/../installdir/bin/:$PATH"
export LUA_PATH="$(pwd)/../installdir/share/luajit-2.1.0-beta3/?.lua;$(pwd)/../installdir/share/lua/5.1/?.lua;;"
export LUA_CPATH="$(pwd)/../installdir/lib/lua/5.1/?.so;;"

love --fused . --f:anonymous --debug --main ItsyScape.BuildLargeTileSetsApplication
LUAJIT="$(pwd)/../installdir/bin/luajit" ../../common/make_bin.sh

cp -rv ~/.local/share/ItsyRealm/Resources/* Resources/

echo $ITSYREALM_VERSION > version.meta

rm -f ../itsyrealm.love && find . -type f | sort | tr "\n" "\0" | xargs -0 zip -0 ../itsyrealm.love

cd ..
cp ./itsyrealm.love ./installdir/bin/itsyrealm.love
