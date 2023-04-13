#!/bin/sh

set -xe

cd build
curl -O -L https://github.com/getsentry/sentry-native/archive/refs/tags/0.6.1.zip
unzip -qo 0.6.1.zip

cd sentry-native-0.6.1
pacman -S --noconfirm --needed - < ./toolchains/msys2-mingw64-pkglist.txt
cd ..

cmake -Bsentry-native-0.6.1-build -Hsentry-native-0.6.1 -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" -DSENTRY_BACKEND=inproc -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=toolchains/msys2.cmake
cmake --build sentry-native-0.6.1-build --parallel
cmake --install sentry-native-0.6.1-build --prefix .

cp ./bin/libsentry.dll ../staging/libsentry.dll
