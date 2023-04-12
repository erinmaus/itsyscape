#!/bin/sh

set -xe

mkdir -p bin
mkdir -p build
mkdir -p staging
mkdir -p staging/ext

./get_premake5.sh
./get_luajit.sh
./get_love.sh
./get_sentry.sh
./get_nbunny.sh
./get_bmashina.sh
./get_discworld.sh
./zip_itsyrealm.sh
./package.sh
