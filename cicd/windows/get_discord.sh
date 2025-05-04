#!/bin/sh

set -xe

mkdir -p build/discord
cd build/discord

curl -O -L https://dl-game-sdk.discordapp.net/3.2.1/discord_game_sdk.zip
unzip -qo discord_game_sdk.zip

mkdir -p ../lib
cp ./lib/x86_64/discord_game_sdk.dll ../lib/discord_game_sdk.dll
cp ./lib/x86_64/discord_game_sdk.dll ../../staging/discord_game_sdk.dll
