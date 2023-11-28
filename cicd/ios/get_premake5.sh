#!/bin/sh

set -xe

cd bin
curl -O -L https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-macosx.tar.gz
tar -xzf premake-5.0.0-beta2-macosx.tar.gz
cp premake5 ../premake5