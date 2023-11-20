#!/bin/sh

set -xe

cd build

git clone https://github.com/love2d/lua-https || true
cd lua-https

cmake -Bbuild \
	-S. \
	-G Xcode \
	-DCMAKE_CXX_STANDARD=11 \
	-DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
	-DLUA_INCLUDE_DIR=$PWD/../include \
	-DLUA_LIBRARIES=$PWD/../lib/liblua51.dylib

pushd build
xcodebuild -configuration Release -scheme https
popd

cp ./build/src/Release/https.so ../../staging/ext/https.so
