#!/bin/bash

set -xe

cd build
git clone https://github.com/erinmaus/slick/ || true
cd slick
git pull

cp -r slick ../../staging/ext/