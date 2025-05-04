#!/bin/sh

set -xe

cp ./itsyrealm_linux/itsyrealm.love ./itsyrealm_linux/LICENSE.txt ./itsyrealm_macos/ItsyRealm.app/Contents/Resources/
cp ./itsyrealm_linux/itsyrealm.love ./itsyrealm_linux/LICENSE.txt ./itsyrealm_windows/itsyrealm.love
rm ./itsyrealm_linux/itsyrealm.love # It's in the AppImage

mkdir -p cicd/macos/build/love2d/platform/xcode
cp itsyrealm_macos cicd/macos/build/love2d/platform/xcode/love-macosxRelease.entitlements

cd cicd/macos
./cicd/macos/codesign.sh ../../itsyrealm_macos/ItsyRealm.app
