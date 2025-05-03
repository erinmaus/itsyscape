#!/bin/sh

set -xe
       
find staging/ItsyRealm.app/Contents/Frameworks -name '*.framework' -exec /usr/bin/codesign --force -s "$MACOS_CERTIFICATE_NAME" --timestamp  {} -v \;
find staging/ItsyRealm.app/Contents/Frameworks -name '*.dylib' -exec /usr/bin/codesign --force -s "$MACOS_CERTIFICATE_NAME" --timestamp  {} -v \;
find staging/ItsyRealm.app/Contents/Frameworks -name '*.so' -exec /usr/bin/codesign --force -s "$MACOS_CERTIFICATE_NAME" --timestamp  {} -v \;
/usr/bin/codesign --timestamp --force -s "$MACOS_CERTIFICATE_NAME" --options runtime staging/ItsyRealm.app --entitlements build/love2d/platform/xcode/love-macosxRelease.entitlements -v
