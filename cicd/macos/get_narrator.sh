#!/bin/sh

set -xe

rm -rf build/lpeg
rm -rf build/narrator

cd build

curl https://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.1.0.tar.gz -o lpeg-1.1.0.tar.gz
tar xzf lpeg-1.1.0.tar.gz
cd lpeg-1.1.0

make CPPFLAGS="-I $(pwd)/../include" CFLAGS="-arch x86_64 -arch arm64" DLLFLAGS="-L $(pwd)/../lib -llua51" lpeg.so
cp lpeg.so ../../staging/ext/lpeg.so

cd ..

rm -rf narrator
git clone --branch 1.8 https://github.com/astrochili/narrator 

rm -rf ../staging/ext/narrator
cp -r narrator/narrator ../staging/ext/
