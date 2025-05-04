#!/bin/sh

set -xe

cp staging/ext/*.dylib staging/ItsyRealm.app/Contents/Frameworks
cp staging/ext/*.so staging/ItsyRealm.app/Contents/Frameworks
