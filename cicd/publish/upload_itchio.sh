#!/bin/sh

cd "$(dirname "$0")"

curl -L https://broth.itch.ovh/butler/darwin-amd64/15.21.0/archive/default -o butler.zip
unzip butler.zip

./butler push itsyrealm_windows.zip erinmaus/itsyrealm:windows
./butler push itsyrealm_linux/love.AppImage erinmaus/itsyrealm:linux
./butler push itsyrealm_macos.zip erinmaus/itsyrealm:macos