#!/bin/sh

set -xe

cd build

git clone https://github.com/love2d/lua-https || true
cd lua-https

cmake -Bbuild-arm64 \
	-S. \
	-G Xcode \
	-DCMAKE_CXX_STANDARD=11 \
	-DCMAKE_SHARED_MODULE_SUFFIX=.dylib \
	-DCMAKE_OSX_ARCHITECTURES=arm64 \
	-DLUA_INCLUDE_DIR=$PWD/../include \
	-DLUA_LIBRARIES=$PWD/../lib/liblua51.dylib

pushd build-arm64
xcodebuild -configuration Release -scheme https
popd

cmake -Bbuild-x64 \
	-S. \
	-G Xcode \
	-DCMAKE_CXX_STANDARD=11 \
	-DCMAKE_SHARED_MODULE_SUFFIX=.dylib \
	-DCMAKE_OSX_ARCHITECTURES=x86_64 \
	-DLUA_INCLUDE_DIR=$PWD/../include \
	-DLUA_LIBRARIES=$PWD/../lib/liblua51.dylib
pushd build-x64
xcodebuild -configuration Release -scheme https
popd

lipo -create -output ../../staging/ext/https.so ./build-arm64/src/Release/https.so ./build-x64/src/Release/https.so
