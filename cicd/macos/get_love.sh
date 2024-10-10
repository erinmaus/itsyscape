#!/bin/sh

set -xe

cd build
git clone https://github.com/erinmaus/love2d || true
git clone -b 11.x https://github.com/love2d/love-apple-dependencies || true

cp ./lib/liblua51.dylib ./love-apple-dependencies/macOS/Frameworks/Lua.framework/Versions/A/Lua
mkdir -p ./love-apple-dependencies/macOS/Frameworks/Lua.framework/Versions/A/Headers
cp ./include/{lauxlib,lua,luaconf,luajit,lualib}.h ./love-apple-dependencies/macOS/Frameworks/Lua.framework/Versions/A/Headers
cp ./include/lua.hpp ./love-apple-dependencies/macOS/Frameworks/Lua.framework/Versions/A/Headers
cp -a ./love-apple-dependencies/macOS/Frameworks ./love2d/platform/xcode/macosx

cd love2d
xcodebuild ONLY_ACTIVE_ARCH=NO clean archive -project platform/xcode/love.xcodeproj -scheme love-macosx -configuration Release -archivePath love-macos.xcarchive
xcodebuild -exportArchive -archivePath love-macos.xcarchive -exportPath ../../staging -exportOptionsPlist platform/xcode/macosx/macos-copy-app.plist
