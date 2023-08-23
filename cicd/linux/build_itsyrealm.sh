#!/bin/sh

set -xe

cd itsyscape && git pull && cd itsyscape
cp -r ../../bmashina/lmashina/lua/B ./B

echo $ITSYREALM_VERSION > version.meta
zip -9 -qr ../../itsyrealm.love .

cd ../..
cp ./itsyrealm.love ./installdir/bin/itsyrealm.love
