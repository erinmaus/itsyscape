#!/bin/sh

set -xe

cd bin
curl -O -L https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-windows.zip
unzip -o premake-5.0.0-beta2-windows.zip
cp premake5.exe ../premake5.exe