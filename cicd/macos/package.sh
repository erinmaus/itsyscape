#!/bin/sh

cp staging/ext/*.dylib staging/ItsyRealm.app/Contents/Frameworks

mkdir -p itsyrealm

rm -rf itsyrealm/ItsyRealm.app
cp -a staging/ItsyRealm.app itsyrealm/ItsyRealm.app
