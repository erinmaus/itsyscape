#!/bin/sh

cd "$(dirname "$0")"

gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /repos/erinmaus/itsyscape/actions/artifacts > artifacts.json

for artifact_name in "itsyrealm_windows" "itsyrealm_linux" "itsyrealm_macos"; do
  artifact_download_url=$(cat ./artifacts.json | jq -r ".artifacts | map(select(.expired != true and .name == \"${artifact_name}\"))[0].archive_download_url")

  if [ $? -ne 0 ] || [ -z "$artifact_download_url" ]; then
    echo "Error: could not get latest artifact download URL of type '${artifact_name}'"
    exit 1
  fi

  echo "Downloading artifact from '${artifact_download_url}' as '${artifact_name}.zip'"

  curl -L \
    -H "Authorization: Bearer $(gh auth token)" \
    "${artifact_download_url}" \
    -o "${artifact_name}.zip"

  if [ $? -ne 0 ]; then
    echo "Could not download artifact."
    exit 1
  fi

  ditto -x -k "./${artifact_name}.zip" "./${artifact_name}"

  if [ $? -ne 0 ]; then
    echo "Could not extract artifact '${artifact_name}.zip'"
    exit 1
  fi
done

# Requires an extra step for macOS
ditto -x -k "./itsyrealm_macos/ItsyRealm.zip" .

if [ $? -ne 0 ]; then
  echo "Could not extract ItsyRealm.app from ${artifact_name}.zip"
  exit 1
fi
