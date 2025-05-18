#!/bin/sh

set -xe

cd build/assets/itsyscape

echo $ITSYREALM_VERSION > version.meta
rm -f ../../../staging/itsyrealm.love && find . -type f | sort | tr "\n" "\0" | xargs -0 -n1 zip -0 ../../../staging/itsyrealm.love
