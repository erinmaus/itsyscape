#!/bin/sh

set -xe
       
find $1/Contents/Frameworks -name '*.framework' -exec /usr/bin/codesign --force -s "$MACOS_CERTIFICATE_NAME" --timestamp  {} -v \;
find $1/Contents/Frameworks -name '*.dylib' -exec /usr/bin/codesign --force -s "$MACOS_CERTIFICATE_NAME" --timestamp  {} -v \;
find $1/Contents/Frameworks -name '*.so' -exec /usr/bin/codesign --force -s "$MACOS_CERTIFICATE_NAME" --timestamp  {} -v \;
/usr/bin/codesign --timestamp --force -s "$MACOS_CERTIFICATE_NAME" --options runtime $1 --entitlements ./build/love2d/platform/xcode/love-macosxRelease.entitlements -v
