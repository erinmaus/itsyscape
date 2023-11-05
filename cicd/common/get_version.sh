#!/bin/sh

latest_version=$(git describe --tags | sed -n 's/\([0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*\).*$/\1/p')

printf -- "${latest_version}"
