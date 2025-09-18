#!/bin/sh

set -xe

ITSYREALM_VERSION=${ITSYREALM_VERSION:=$(../common/make_version.sh)}

cd ../..

echo $ITSYREALM_VERSION > itsyscape/version.meta

if [ -z "SKIP_COMPILING_ASSETS" ]; then
	if [ -z "$LOVE_BINARY" ]; then
		pushd ./cicd/macos
		./build.sh
		rm -f ./staging/ItsyRealm.app/Contents/Resources/itsyrealm.love
		LOVE_BINARY="$(pwd)/itsyrealm/ItsyRealm.app/Contents/MacOS/ItsyRealm"
		popd
	fi

	frameworks_path="$(dirname $LOVE_BINARY)/../Frameworks/"
	LUA_CPATH="$frameworks_path/?.dylib;$frameworks_path/?.so" "$LOVE_BINARY" --fused itsyscape --f:anonymous --debug --main ItsyScape.BuildLargeTileSetsApplication

fi
	cp -vr "$HOME/Library/Application Support/ItsyRealm/Resources/"* ./itsyscape/Resources
	./cicd/common/make_bin.sh

cd itsyscape
cp -r ../cicd/ios/staging/ext/B ./B
cp -r ../cicd/ios/staging/ext/devi ./devi
cp -r ../cicd/ios/staging/ext/nomicon ./nomicon
cp -r ../cicd/ios/staging/ext/slick ./slick
rm -f ../cicd/ios/staging/itsyrealm.love
zip -0 -oXqr ../cicd/ios/staging/itsyrealm.love .
rm -r ./B
rm -r ./devi
rm -r ./nomicon
rm -r ./slick
rm -rf ./Player/Default.dat
rm -rf ./Player/Common.dat