#!/bin/sh

set -xe

ITSYREALM_VERSION=${ITSYREALM_VERSION:=$(../common/make_version.sh)}

cd ../../itsyscape

echo $ITSYREALM_VERSION > version.meta

if [ "$1" != "release" ]; then
	if [ -f "$HOME/Library/Application Support/ItsyRealm/Player/Default.dat" ]; then
		mkdir -p Player
		cp "$HOME/Library/Application Support/ItsyRealm/Player/Default.dat" ./Player/Default.dat
	fi

	if [ -f "$HOME/Library/Application Support/ItsyRealm/Player/Common.dat" ]; then
		mkdir -p Player
		cp "$HOME/Library/Application Support/ItsyRealm/Player/Common.dat" ./Player/Common.dat
	fi
fi

cp -r ../cicd/ios/staging/ext/B ./B
cp -r ../cicd/ios/staging/ext/devi ./devi
rm -f ../cicd/ios/staging/itsyrealm.love
zip -9 -qr ../cicd/ios/staging/itsyrealm.love .
rm -r ./B
rm -r ./devi
rm -rf ./Player/Default.dat
rm -rf ./Player/Common.dat