#!/bin/sh

set -xe

cd ../../itsyscape

echo $ITSYREALM_VERSION > version.meta
zip -9 -qr ../cicd/windows/staging/itsyrealm.love .
