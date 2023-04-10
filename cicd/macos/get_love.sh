#!/bin/sh

set -xe

cd build
git clone https://github.com/erinmaus/love2d || true
git clone https://github.com/love2d/love-apple-dependencies || true

cd love2d
cp -a ../love-apple-dependencies/macOS/Frameworks platform/xcode/macosx
cp ../lib/liblua51.dylib platform/xcode/macosx/Frameworks/Lua.framework/Versions/A/Lua
mkdir -p platform/xcode/macosx/Frameworks/Lua.framework/Versions/A/Headers
cp ../include/*.h platform/xcode/macosx/Frameworks/Lua.framework/Versions/A/Headers
cp ../include/*.hpp platform/xcode/macosx/Frameworks/Lua.framework/Versions/A/Headers

xcodebuild clean archive -project platform/xcode/love.xcodeproj -scheme love-macosx -configuration Release -archivePath love-macos.xcarchive
xcodebuild -exportArchive -archivePath love-macos.xcarchive -exportPath ../../staging -exportOptionsPlist platform/xcode/macosx/macos-copy-app.plist
