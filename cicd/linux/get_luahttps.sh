#!/bin/sh

set -xe

git clone https://github.com/love2d/lua-https || true
cd lua-https

cmake \
	-Bbuild \
	-H. \
	-DCMAKE_INSTALL_PREFIX=$(pwd)/../installdir \
	-DLUA_INCLUDE_DIR=$(pwd)/../installdir/include/luajit-2.1 \
	-DLUA_LIBRARIES=$(pwd)/../installdir/lib/luajit-5.1.so

cmake --build build --config Release --target install

cd ..

mv installdir/https.so installdir/lib/lua/5.1/https.so
