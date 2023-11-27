#!/bin/sh

set -xe

cd ../../itsyscape
echo $ITSYREALM_VERSION > version.meta

cp -r ../cicd/ios/staging/ext/B ./B
zip -9 -qr ../cicd/ios/staging/itsyrealm.love .
rm -r ./B
