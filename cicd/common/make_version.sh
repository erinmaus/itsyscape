#!/bin/sh

if [ ! -z "$ITSYREALM_VERSION_OVERRIDE" ]; then
    latest_version="$ITSYREALM_VERSION_OVERRIDE"
else
    latest_version=$(git describe --tags | sed -n 's/\([0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*\).*$/\1/p')
fi

commit_version=$(git rev-parse --short=8 $latest_version)
build_version=$(git rev-list --count ${latest_version}..HEAD)

if [ "$1" == "simple" ]; then
    printf -- "${latest_version}"
elif [ "$1" == "build" ]; then
    printf -- "${latest_version}.${build_version}"
else
    printf -- "${latest_version}-${commit_version}"
fi
