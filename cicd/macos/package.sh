#!/bin/sh

./codesign.sh staging/ItsyRealm.app

mkdir -p itsyrealm

rm -rf itsyrealm/ItsyRealm.app
cp -a staging/ItsyRealm.app itsyrealm/ItsyRealm.app
