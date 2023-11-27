#!/bin/sh

set -xe

cd build
curl -O -L https://curl.se/download/curl-8.0.1.tar.gz
tar xzf curl-8.0.1.tar.gz
cd curl-8.0.1

export CPPFLAGS="-DCURL_BUILD_IOS"
export CFLAGS="-arch arm64 -pipe -isysroot $(xcrun --sdk iphoneos --show-sdk-path) -miphoneos-version-min=13.0"
export LDFLAGS="-arch arm64 -isysroot $(xcrun --sdk iphoneos --show-sdk-path)"
./configure --without-zlib --enable-static --enable-ipv6 --with-secure-transport --host="arm-apple-darwin" --prefix="$(pwd)/.."
make -j8
make install

install_name_tool -id "@rpath/curl.framework/curl" ../lib/libcurl.dylib

cd ..

curl -O -L https://github.com/getsentry/sentry-native/archive/refs/tags/0.6.1.zip
unzip -qo 0.6.1.zip

cmake -Bsentry-native-0.6.1-build \
	-Hsentry-native-0.6.1 \
	-DCMAKE_OSX_SYSROOT=$(xcrun --sdk iphoneos --show-sdk-path) \
	-DCMAKE_OSX_ARCHITECTURES="arm64" \
	-DSENTRY_BACKEND=inproc \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=$(pwd)

cmake --build sentry-native-0.6.1-build --parallel
cmake --install sentry-native-0.6.1-build --prefix .

install_name_tool -id "@rpath/sentry.framework/sentry" ./lib/libsentry.dylib

cp ./lib/libsentry.dylib ../staging/ext/sentry.dylib
cp ./lib/libcurl.dylib ../staging/ext/curl.dylib