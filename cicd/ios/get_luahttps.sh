#!/bin/sh

set -xe

cd build

git clone https://github.com/love2d/lua-https || true
cd lua-https

sed -i '' 's/MODULE/SHARED/g' ./src/CMakeLists.txt

cmake -Bbuild \
	-S. \
	-G Xcode \
	-DCMAKE_CXX_STANDARD=11 \
	-DCMAKE_OSX_SYSROOT=$(xcrun --sdk iphoneos --show-sdk-path) \
	-DCMAKE_OSX_ARCHITECTURES="arm64" \
	-DLUA_INCLUDE_DIR=$(pwd)/../include \
	-DCMAKE_OSX_DEPLOYMENT_TARGET="13.0" \
	-DLUA_LIBRARIES=$(pwd)/../lib/liblua51.a

pushd build
xcodebuild -configuration Release -scheme https -sdk iphoneos CODE_SIGNING_ALLOWED=NO
popd

cp ./build/src/Release*/https.dylib ../../staging/ext/https.dylib
