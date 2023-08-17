#!/bin/sh

set -xe

apt-get update
sudo apt-get --assume-yes install libarchive-tools

mkdir tmp && cd tmp

curl -O -L https://releases.ubuntu.com/18.04/ubuntu-18.04.6-live-server-amd64.iso
bsdtar xf ubuntu-18.04.6-live-server-amd64.iso

cd ..

mkdir -p /mnt
mount -t squashfs $(pwd)/tmp/casper/filesystem.squashfs /mnt

cp -a /mnt/* .

cp /etc/resolv.conf ./etc/resolv.conf

mount -t proc none $(pwd)/proc
mount -o bind /dev $(pwd)/dev
mount -o bind /sys $(pwd)/sys
