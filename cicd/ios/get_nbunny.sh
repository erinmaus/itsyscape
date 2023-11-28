#!/bin/sh

set -xe

export CPPFLAGS="-I ../love2d/src -I ../love2d/src/modules -I ../include"
export CFLAGS="-stdlib=libc++ -g3"
export LDFLAGS="-L $(pwd)/.. -lsentry -stdlib=libc++ -llua51 -framework love -F $(pwd)/build/lib"

rm -rf build/nbunny
cp -r ../../utilities build/nbunny

cd build
git clone https://github.com/g-truc/glm || true
cp -r ./glm/glm ./include

cd nbunny

export CC="$(xcrun --sdk iphoneos --find clang) -isysroot $(xcrun --sdk iphoneos --show-sdk-path) -arch arm64 -fPIC -miphoneos-version-min=13.0"
export CXX="$(xcrun --sdk iphoneos --find clang++) -isysroot $(xcrun --sdk iphoneos --show-sdk-path) -arch arm64 -fPIC -miphoneos-version-min=13.0"
export LD="$(xcrun --sdk iphoneos --find ld) -isysroot $(xcrun --sdk iphoneos --show-sdk-path)  -arch arm64 -all_load"

../../premake5 --deps=.. --os=ios gmake

make config=release_arm64 clean
CFLAGS="${CFLAGS} -arch arm64 -g3" LDFLAGS="${LDFLAGS} -arch arm64" config=release_arm64 make nbunny

cp ./bin/libnbunny.dylib ../../staging/ext/nbunny.dylib
