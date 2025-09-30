#!/bin/sh

set -xe

ITSYREALM_VERSION=${ITSYREALM_VERSION:-$(../common/make_version.sh)}

cd build/assets/itsyscape

echo $ITSYREALM_VERSION > version.meta
rm -f ../../../staging/itsyrealm.love && find . -type f | sort | tr "\n" "\0" | xargs -0 zip -0 ../../../staging/itsyrealm.love
