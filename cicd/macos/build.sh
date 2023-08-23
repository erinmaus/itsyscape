#!/bin/sh

export MAKEFLAGS="-j4"

export ITSYREALM_VERSION=$(../common/make_version.sh)
echo "Building ItsyRealm ${ITSYREALM_VERSION}"

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
