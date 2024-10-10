#!/bin/sh

set -xe

rm -rf build/JoyShockLibrary
pushd build

git clone https://github.com/JibbSmart/JoyShockLibrary
cd JoyShockLibrary

git apply ../../patch/JoyShockLibrary.patch
cp -r ../../patch/JoyShockLibrary/* .

cmake -Bbuild \
	-S. \
	-DCMAKE_OSX_DEPLOYMENT_TARGET=14 \
	-DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
	-DCMAKE_SKIP_RPATH=ON \
	-DBUILD_SHARED_LIBS=ON

pushd build
cmake --build . --parallel
popd

cp ./build/JoyShockLibrary/libJoyShockLibrary.dylib ../lib
cp ./build/build/_deps/hidapi-src/src/mac/libhidapi.dylib ../lib
cp ./build/JoyShockLibrary/libJoyShockLibrary.dylib ../../staging/ext
cp ./build/build/_deps/hidapi-src/src/mac/libhidapi.0.dylib ../../staging/ext
cp ./JoyShockLibrary/JoyShockLibrary.h ../include

popd

export CPPFLAGS="-I ../love2d/src -I ../love2d/src/modules -I ../include -stdlib=libc++"
export LDFLAGS="-L $(pwd)/.. -lsentry -lJoyShockLibrary -stdlib=libc++ -framework Lua -framework love -F $(pwd)/staging/ItsyRealm.app/Contents/Frameworks"

rm -rf build/nbunny
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
