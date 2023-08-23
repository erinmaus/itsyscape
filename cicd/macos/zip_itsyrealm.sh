#!/bin/sh

set -xe

cd ../../itsyscape
echo $ITSYREALM_VERSION > version.meta

cp -r ../cicd/macos/staging/ext/B ./B
zip -9 -qr ../cicd/macos/staging/ItsyRealm.app/Contents/Resources/itsyrealm.love .
rm -r ./B
