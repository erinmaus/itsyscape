#!/bin/sh

cd "$(dirname "$0")"

key_json=$(\
	gh api \
		-H "Accept: application/vnd.github+json" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		/repos/erinmaus/itsyscape/actions/secrets/public-key
)

if [ $? -ne 0 ] || [ -z "$key_json" ]; then
	echo "Error: could not public key ID for ItsyRealm repo."
	exit 1
fi

public_key_id=$(echo $key_json | jq -r '.key_id')
public_key=$(echo $key_json | jq -r '.key')

if [ -z "$public_key_id"] ] || [ -z "$public_key" ]; then
	echo "Error: could not public key ID and/or public key value for ItsyRealm repo."
	exit 1
fi

steam_cicd_username=${STEAM_CICD_USERNAME:=`read -s -p "Username:" value; echo $value`}
steam_cicd_password=${STEAM_CICD_PASSWORD:=`read -s -p "Password:" value; echo $value`}

# Assumes macOS

mv "$HOME/Library/Application Support/Steam/config/config.vdf" "$HOME/Library/Application Support/Steam/config/config.vdf.bak"

steamcmd +login ${steam_cicd_username} ${steam_cicd_password} +quit

if [ $? -ne 0 ]; then
	echo "Could not log in to Steam."
	exit 1
fi

npm install libsodium-wrappers
secret=$(GH_PUBLIC_KEY="${public_key}" CONFIG_VDF_FILENAME="$HOME/Library/Application Support/Steam/config/config.vdf" node ./encrypt_secret.js)

gh api \
	--method PUT \
	-H "Accept: application/vnd.github+json" \
	-H "X-GitHub-Api-Version: 2022-11-28" \
	/repos/erinmaus/itsyscape/actions/secrets/STEAM_CONFIG_VDF \
	-f encrypted_value="${secret}" \
	-f key_id="$public_key_id" > /dev/null

if [ $? -ne 0 ]; then
	echo "Could not update GitHub secret STEAM_CONFIG_VDF."
	exit 1
fi
