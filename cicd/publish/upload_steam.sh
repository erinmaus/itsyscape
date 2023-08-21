#!/bin/sh

cd "$(dirname "$0")"

brew install --cask steamcmd

mkdir -p "$HOME/Library/Application Support/Steam/config"
echo "${STEAM_CONFIG_VDF}" > "$HOME/Library/Application Support/Steam/config/config.vdf"

steamcmd +login ${STEAM_CICD_USERNAME} +run_app_build $(pwd)/$1 +quit
