#!/bin/bash

set -xe

cd build
git clone https://github.com/erinmaus/nomicon/ || true
cd nomicon
git pull

cp -r nomicon ../../staging/ext/