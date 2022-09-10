#!/bin/sh

set -x

curl -L https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-src.zip -o premake-5.0.0-beta2-src.zip
mkdir -p premake5 && cd premake5
unzip -qo ../premake-5.0.0-beta2-src.zip
cd premake-5.0.0-beta2-src/build/gmake2.unix/
make config=release
cd ../..
cp bin/release/premake5 ..
