#!/bin/sh

set -xe

cd build
git clone https://github.com/erinmaus/love2d || true
git clone https://github.com/love2d/love-apple-dependencies || true

cd love2d
cp -a ../love-apple-dependencies/iOS/libraries platform/xcode/ios
rm -rf platform/xcode/ios/libraries/Lua.xcframework
cp -R ../lib/Lua.xcframework platform/xcode/ios/libraries

xcodebuild clean archive -project platform/xcode/love.xcodeproj -scheme love-ios -configuration Debug -archivePath love-ios.xcarchive CODE_SIGNING_ALLOWED=NO
xcodebuild clean archive -project platform/xcode/liblove.xcodeproj -scheme liblove-ios-framework -configuration Debug -sdk iphoneos -archivePath liblove-ios.xcarchive SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
ls -la ./liblove-ios.xcarchive/Products/Library/Frameworks/*
cp -R ./liblove-ios.xcarchive/Products/Library/Frameworks/* ../lib
xcodebuild -exportArchive -archivePath love-ios.xcarchive -exportPath ../../staging -exportOptionsPlist platform/xcode/ios/love-ios.plist