#!/bin/sh

set -xe

curl -O -L https://www.openssl.org/source/openssl-3.1.0.tar.gz
tar xzf openssl-3.1.0.tar.gz
cd openssl-3.1.0
./Configure --prefix=$(pwd)/../installdir
LDFLAGS="-Wl,-rpath,'\$ORIGIN/../lib'" make
make install

cd ..

curl -O -L https://curl.se/download/curl-8.0.1.tar.gz
tar xzf curl-8.0.1.tar.gz
cd curl-8.0.1
./configure --prefix=$(pwd)/../installdir --with-openssl=$(pwd)/../installdir
LDFLAGS="-Wl,-rpath,'\$ORIGIN/../lib'" make
make install

cd ..

curl -O -L https://github.com/getsentry/sentry-native/archive/refs/tags/0.6.1.zip
unzip -qo 0.6.1.zip

cmake -Bsentry-native-0.6.1-build -Hsentry-native-0.6.1 -DSENTRY_BACKEND=inproc -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$(pwd)/installdir -DCMAKE_INSTALL_PREFIX=$(pwd)/installdir
cmake --build sentry-native-0.6.1-build --parallel
cmake --install sentry-native-0.6.1-build --prefix ./installdir
