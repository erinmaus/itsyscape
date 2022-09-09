#!/bin/sh

set -xe

cd itsyscape && git pull && cd itsyscape
cp -r ../../bmashina/lmashina/lua/B ./B
zip -9 -qfr ../../itsyrealm.love .
cd ../..
