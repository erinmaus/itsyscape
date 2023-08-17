#!/bin/sh

set -xe

docker run -v $(pwd):/itsyrealm ubuntu:18.04 /bin/bash -c 'cd /itsyrealm && ./cicd/linux/build.sh'
