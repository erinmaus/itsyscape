#!/bin/sh

cd "$(dirname "$0")"

set -xe

cp ./itsyrealm_linux/itsyrealm.love ./itsyrealm_linux/LICENSE.txt ./itsyrealm_macos/ItsyRealm.app/Contents/Resources/
cp ./itsyrealm_linux/itsyrealm.love ./itsyrealm_linux/LICENSE.txt ./itsyrealm_windows/
cp ./itsyrealm_linux/LICENSE.txt ./itsyrealm_linux/installdir/LICENSE.txt

mkdir -p ../macos/build/love2d/platform/xcode
cp itsyrealm_macos/build/love2d/platform/xcode/love-macosxRelease.entitlements ../macos/build/love2d/platform/xcode/love-macosxRelease.entitlements

cd ../macos
./codesign.sh ../publish/itsyrealm_macos/ItsyRealm.app
