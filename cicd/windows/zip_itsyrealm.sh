#!/bin/sh

set -xe

cd build/assets/itsyscape

echo $ITSYREALM_VERSION > version.meta
zip -9 -qr ../../staging/itsyrealm.love .
