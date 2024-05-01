#!/bin/sh

set -xe

cd build

git clone https://github.com/love2d/lua-https || true
cd lua-https

sed -i '' 's/CMAKE_CXX_STANDARD 11/CMAKE_CXX_STANDARD 14/g' ./src/CMakeLists.txt

cmake \
	-Bbuild \
	-S. \
	-DCMAKE_INSTALL_PREFIX=$(pwd)/.. \
	-G "MSYS Makefiles" \
	-DLUA_INCLUDE_DIR=$(pwd)/../include \
	-DLUA_LIBRARIES=$(pwd)/../lib/lua51.dll

cmake --build build --config Release --target install

cp ../https.dll ../../staging/ext/https.dll || true

ls -la ../../staging/ext
