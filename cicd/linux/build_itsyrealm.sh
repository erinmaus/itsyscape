#!/bin/sh

set -xe

rm -rf itsyscape-love
cp -r ../../itsyscape itsyscape-love
cd itsyscape-love

cp -r ../bmashina/lmashina/lua/B ./B
cp -r ../devi/devi ./devi

cp -r ../nomicon/nomicon ./nomicon

mkdir -p ./Player
cp ../Common.dat ./Player/Common.dat

echo $ITSYREALM_VERSION > version.meta
zip -9 -qr ../itsyrealm.love .

cd ..
cp ./itsyrealm.love ./installdir/bin/itsyrealm.love
