#!/bin/sh

set -xe

add-apt-repository ppa:ubuntu-toolchain-r/test
apt-get update
apt-get install --assume-yes gcc-11 g++-11

update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100
update-alternatives --install /usr/bin/cpp cpp-bin /usr/bin/cpp-11 100
update-alternatives --set g++ /usr/bin/g++-11
update-alternatives --set gcc /usr/bin/gcc-11
update-alternatives --set cpp-bin /usr/bin/cpp-11

gcc --version
