#!/bin/sh

set -xe

ITSYREALM_VERSION=${ITSYREALM_VERSION:=$(../common/make_version.sh)}

cd ../../itsyscape

echo $ITSYREALM_VERSION > version.meta

if [ -f "$HOME/Library/Application Support/ItsyRealm/Player/Default.dat" ]; then
	mkdir -p Player
	cp "$HOME/Library/Application Support/ItsyRealm/Player/Default.dat" ./Player/Default.dat
fi

if [ -f "$HOME/Library/Application Support/ItsyRealm/Player/Common.dat" ]; then
	mkdir -p Player
	cp "$HOME/Library/Application Support/ItsyRealm/Player/Common.dat" ./Player/Common.dat
fi

cp -r ../cicd/ios/staging/ext/B ./B
zip -9 -qr ../cicd/ios/staging/itsyrealm.love .
rm -r ./B
rm -rf ./Player/Default.dat
rm -rf ./Player/Common.dat