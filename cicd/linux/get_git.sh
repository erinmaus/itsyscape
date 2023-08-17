#!/bin/sh

set -xe

add-apt-repository ppa:git-core/ppa
apt-get install --assume-yes git

git config --global --add safe.directory /itsyrealm

git --version
