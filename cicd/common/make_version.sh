#!/bin/sh

latest_version=$(git describe --tags | sed -n 's/\([0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*\).*$/\1/p')
commit_version=$(git rev-parse --short=8 HEAD)

printf -- "${latest_version}-${commit_version}"
