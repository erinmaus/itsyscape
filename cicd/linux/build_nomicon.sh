#!/bin/bash

set -xe

git clone https://github.com/erinmaus/nomicon/ || true
cd nomicon
git pull
