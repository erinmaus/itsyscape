#!/bin/sh

set -xe

cd itsyscape && git pull && cd itsyscape
cp -r ../../bmashina/lmashina/lua/B ./B
zip -9 -qr ../../itsyrealm.love .
cd ../..
