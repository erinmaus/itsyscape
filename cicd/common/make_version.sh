#!/bin/sh

name=$(git describe --tags --abbrev=0)

if [ ! -z "$ITSYREALM_VERSION_OVERRIDE" ]; then
    latest_version="$ITSYREALM_VERSION_OVERRIDE"
fi

if [ ! -z "$ITSYREALM_BUILD_OVERRIDE" ]; then
    build_environment="$ITSYREALM_BUILD_OVERRIDE"
fi

latest_version=${latest_version:-$(echo $name | sed -n 's/.*-\([0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*\).*$/\1/p')}
build_environment=${build_environment:-$(echo $name | sed -n 's/.*-[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*-\([a-zA-Z_][a-zA-Z0-9_]*\).*$/\1/p')}

commit_version=$(git rev-parse --short=8 $name)
build_version=$(git rev-list --count ${name}..HEAD)

if [ "$1" == "simple" ]; then
    printf -- "${latest_version}"
elif [ "$1" == "build" ]; then
    printf -- "${latest_version}.${build_version}"
elif [ "$1" != "env" ]; then
    printf -- "${latest_version}.${build_version}-${commit_version}-${build_environment:-production}"
fi

export ITSYRELAM_MAJOR=$(echo $latest_version | sed -n 's/\([0-9][0-9]*\).[0-9][0-9]*.[0-9][0-9]*.*$/\1/p')
export ITSYREALM_MINOR=$(echo $latest_version | sed -n 's/[0-9][0-9]*.\([0-9][0-9]*\).[0-9][0-9]*.*$/\1/p')
export ITSYREALM_REVISION=$(echo $latest_version | sed -n 's/[0-9][0-9]*.[0-9][0-9]*.\([0-9][0-9]*\).*$/\1/p')
export ITSYREALM_BUILD="${build_version:-0}"
export ITSYREALM_ENVIRONMENT="${build_environment:-production}"
