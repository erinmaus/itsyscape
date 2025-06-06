#!/bin/sh

set -xe

add-apt-repository ppa:git-core/ppa -y
apt-get install --assume-yes git

git config --global --add safe.directory /itsyrealm

git --version
