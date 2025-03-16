#!/bin/sh

name=$(git symbolic-ref -q --short HEAD || git describe --tags --exact-match)
if [ ! -z "$ITSYREALM_VERSION_OVERRIDE" ]; then
    latest_version="$ITSYREALM_VERSION_OVERRIDE"
else
    latest_version=$(echo $name | sed -n 's/.*-\([0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*\).*$/\1/p')
fi

commit_version=$(git rev-parse --short=8 $name)
build_version=$(git rev-list --count ${name}..HEAD)

if [ "$1" == "simple" ]; then
    printf -- "${latest_version}"
elif [ "$1" == "build" ]; then
    printf -- "${latest_version}.${build_version}"
else
    printf -- "${latest_version}.${build_version}-${commit_version}"
fi
