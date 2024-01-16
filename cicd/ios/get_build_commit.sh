#!/bin/zsh

if [ -z "$2" ]; then
    latest_version=$(git describe --tags | sed -n 's/\([0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*\).*$/\1/p')
else
    latest_version="$2"
fi

build_count=$(git rev-list --count ${latest_version}..HEAD)

git log --reverse --pretty=format:"%H" -n$(expr $build_count - $1) | head -n1