#!/bin/sh

set -xe

cd build

mkdir -p assets
cd assets

cp -r ../../../../itsyscape itsyscape

../staging/lovec.exe --fused ./itsyscape /f:anonymous /main ItsyScape.BuildLargeTileSetsApplication

cp -r $APPDATA/ItsyRealm/Resources/* ./itsyscape/Resources
