#!/bin/sh

set -xe

cd build/assets/itsyscape

echo $ITSYREALM_VERSION > version.meta
zip -0 -oXqr ../../../staging/itsyrealm.love .
