#!/bin/sh

set -xe

cd ./cicd/linux

export DEBIAN_FRONTEND=noninteractive
export CI="1"

apt-get update

apt-get install --assume-yes build-essential git make cmake autoconf automake \
  libtool pkg-config libasound2-dev libpulse-dev libaudio-dev \
  libjack-dev libx11-dev libxext-dev libxrandr-dev libxcursor-dev \
  libxfixes-dev libxi-dev libxinerama-dev libxxf86vm-dev libxss-dev \
  libgl1-mesa-dev libdbus-1-dev libudev-dev libgles2-mesa-dev \
  libegl1-mesa-dev libibus-1.0-dev fcitx-libs-dev libsamplerate0-dev \
  libsndio-dev libwayland-dev libxkbcommon-dev libdrm-dev libgbm-dev \
  xvfb xorg openbox

apt-get install --assume-yes libglm-dev curl unzip libboost-all-dev fuse libfuse2 zip \
  software-properties-common

export DISPLAY=":99"
Xvfb $DISPLAY -screen 0, 360x240x24 &
sleep 5
openbox &

./get_git.sh
./get_gcc.sh

export LOVE_BRANCH=master
export ITSYREALM_BRANCH=$(git rev-parse --abbrev-ref HEAD)
export ITSYREALM_VERSION=$(../common/make_version.sh)
echo "Building ItsyRealm ${ITSYREALM_VERSION}"


git clone https://github.com/erinmaus/love2d love2d-${LOVE_BRANCH} || true

rm -rf installdir/bin/love

make LOVE_BRANCH=${LOVE_BRANCH}

./get_premake5.sh
./build_sentry.sh
./get_luahttps.sh
./build_bmashina.sh
./build_discworld.sh
./build_nbunny.sh
./build_devi.sh
./build_nomicon.sh
./build_itsyrealm.sh

rm love-${LOVE_BRANCH}.AppImage

make LOVE_BRANCH=${LOVE_BRANCH}

mv love-${LOVE_BRANCH}.AppImage itsyrealm.AppImage
cp ../../ext/LICENSE.txt LICENSE.txt

pwd
ls -l
