#!/bin/sh

set -xe

xcrun altool --validate-app -f itsyrealm/ItsyRealm.ipa -t ios -u "$MACOS_NOTARIZATION_APPLE_ID" -p "$MACOS_NOTARIZATION_PASSWORD"
xcrun altool --upload-app --type ios --file itsyrealm/ItsyRealm.ipa -u "$MACOS_NOTARIZATION_APPLE_ID" -p "$MACOS_NOTARIZATION_PASSWORD"
