#!/bin/sh

set -xe

cd ../../itsyscape
echo $ITSYREALM_VERSION > version.meta

if [ -f "$HOME/Library/Application Support/ItsyRealm/Player/Default.dat" ]; then
	mkdir -p Player
	cp "$HOME/Library/Application Support/ItsyRealm/Player/Default.dat" ./Player/Default.dat
fi

cp -r ../cicd/ios/staging/ext/B ./B
zip -9 -qr ../cicd/ios/staging/itsyrealm.love .
rm -r ./B
rm -rf ./Player/Default.dat