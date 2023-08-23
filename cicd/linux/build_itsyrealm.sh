#!/bin/sh

set -xe

rm -rf itsyscape-love
cp -r ../../itsyscape itsyscape-love
cd itsyscape-love

cp -r ../bmashina/lmashina/lua/B ./B

echo $ITSYREALM_VERSION > version.meta
zip -9 -qr ../itsyrealm.love .

cd ..
cp ./itsyrealm.love ./installdir/bin/itsyrealm.love
