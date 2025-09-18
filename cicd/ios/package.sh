#!/bin/sh


set -xe

cd staging

rm -rf Payload Symbols Signatures ItsyRealm_signed.ipa
unzip -q ItsyRealm.ipa

rm -rf ./Payload/ItsyRealm.app/_CodeSignatures/*

PROFILE_PATH="$HOME/Library/MobileDevice/Provisioning Profiles/${IOS_PROFILE_FILENAME}"
rm -rf ./Payload/ItsyRealm.app/embedded.mobileprovision
cp "$PROFILE_PATH" ./Payload/ItsyRealm.app/embedded.mobileprovision

security cms -D -i "$PROFILE_PATH" > provision.plist
/usr/libexec/PlistBuddy -x -c 'Print :Entitlements' provision.plist > entitlements.plist

find ./ext -name '*.so' -exec ../build_framework.sh {} \;
find ./ext -name '*.dylib' -exec ../build_framework.sh {} \;

defaults write "$(pwd)/Payload/ItsyRealm.app/Info.plist" CFBundleShortVersionString -string $(../../common/make_version.sh simple)
defaults write "$(pwd)/Payload/ItsyRealm.app/Info.plist" CFBundleVersion -string $(../../common/make_version.sh build)
defaults write "$(pwd)/Payload/ItsyRealm.app/Info.plist" ITSAppUsesNonExemptEncryption -bool no

cp ./itsyrealm.love ./Payload/ItsyRealm.app/itsyrealm.love

/usr/bin/codesign --force -s "$IOS_CERTIFICATE_NAME" Payload/ItsyRealm.app/Frameworks/* -v	
/usr/bin/codesign --force -s "$IOS_CERTIFICATE_NAME" --entitlements ./entitlements.plist Payload/ItsyRealm.app -v

rm -rf ../itsyrealm/ItsyRealm.ipa
zip -qr ../itsyrealm/ItsyRealm.ipa Payload
