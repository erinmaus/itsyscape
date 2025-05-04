#!/bin/sh

cd "$(dirname "$0")"

source ../common/make_version.sh "env"

if [ $ITSYREALM_ENVIRONMENT == "demo" ]; then
	export ITSYREALM_VDF="itsyrealm_demo.vdf"
else
	export ITSYREALM_VDF="itsyrealm.vdf"
fi

brew install --cask steamcmd

mkdir -p "$HOME/Library/Application Support/Steam/config"
echo "${STEAM_CONFIG_VDF}" > "$HOME/Library/Application Support/Steam/config/config.vdf"

ITSYREALM_VDF="$(pwd)/$ITSYREALM_VDF"
upload_steam () {
	steamcmd +login ${STEAM_CICD_USERNAME} +run_app_build "$ITSYREALM_VDF" +quit
}

upload_steam
while [ $? -ne 0 ]; do
	echo "Failed to upload to Steam. Trying again in 5 seconds..."
	sleep 5

	upload_steam
done
