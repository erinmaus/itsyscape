#!/bin/sh

set -xe

git config --global core.autocrlf true

export PATH=/mingw64/bin:$PATH

mkdir -p bin
mkdir -p build
mkdir -p staging

./get_love.sh
./get_premake5.sh
./get_discord.sh
./get_luajit.sh
./get_bmashina.sh
./get_discworld.sh
./get_nbunny.sh
./zip_itsyrealm.sh

cp -r staging itsyrealm