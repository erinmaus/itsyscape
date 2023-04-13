#!/bin/sh

set -xe

cd build
curl -O -L https://github.com/getsentry/sentry-native/archive/refs/tags/0.6.1.zip
unzip -qo 0.6.1.zip

cmake -Bsentry-native-0.6.1-build -Hsentry-native-0.6.1 -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" -DSENTRY_BACKEND=inproc -DCMAKE_BUILD_TYPE=Release
cmake --build sentry-native-0.6.1-build --parallel
cmake --install sentry-native-0.6.1-build --prefix .

cp ./lib/libsentry.dylib ../staging/ext