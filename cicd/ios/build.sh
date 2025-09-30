#!/bin/sh

export MAKEFLAGS="-j4"

export ITSYREALM_VERSION=$(../common/make_version.sh)
echo "Building ItsyRealm ${ITSYREALM_VERSION}"

set -xe

if [ ! -z "${CI}" ]; then
	sudo xcode-select -s /Applications/Xcode_15.0.1.app
fi

mkdir -p bin
mkdir -p build
mkdir -p staging
mkdir -p staging/ext
mkdir -p itsyrealm

./get_premake5.sh
./get_luajit.sh
./get_luahttps.sh
./get_love.sh
./get_sentry.sh
./get_nbunny.sh
./get_bmashina.sh
./get_discworld.sh
./get_devi.sh
./get_nomicon.sh
./get_slick.sh
./zip_itsyrealm.sh
./package.sh
