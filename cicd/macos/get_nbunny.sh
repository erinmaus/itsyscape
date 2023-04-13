#!/bin/sh

set -xe

export CPPFLAGS="-I ../love2d/src -I ../love2d/src/modules -I ../include -stdlib=libc++"
export LDFLAGS="-L $(pwd)/.. -lsentry -stdlib=libc++ -framework Lua -framework love -F $(pwd)/staging/ItsyRealm.app/Contents/Frameworks"

cp -r ../../utilities build/nbunny

cd build
git clone https://github.com/g-truc/glm || true
cp -r ./glm/glm ./include

cd nbunny

../../premake5 --deps=.. gmake

config=release_arm64 make clean
CPPFLAGS="${CPPFLAGS} -arch x86_64" LDFLAGS="${LDFLAGS} -arch x86_64" config=release_arm64 make nbunny
cp ./bin/libnbunny.dylib ./bin/libnbunny_intel.dylib

config=release_arm64 make clean
CPPFLAGS="${CPPFLAGS} -arch arm64" LDFLAGS="${LDFLAGS} -arch arm64" config=release_arm64 make nbunny
cp ./bin/libnbunny.dylib ./bin/libnbunny_m1.dylib

lipo -create -output ./bin/libnbunny.dylib ./bin/libnbunny_intel.dylib ./bin/libnbunny_m1.dylib

cp ./bin/libnbunny.dylib ../../staging/ext/nbunny.dylib
