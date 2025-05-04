#!/bin/sh

name=$(git symbolic-ref -q --short HEAD || git describe --tags --exact-match)
if [ ! -z "$ITSYREALM_DEMO_OVERRIDE" ]; then
    is_demo="$ITSYREALM_DEMO_OVERRIDE"
else
    is_demo=$(echo $name | sed -n 's/^.*-\(demo\)$/\1/p')
fi

if [ -z "$ITSYREALM_DEMO_OVERRIDE" ]; then
    is_demo="production"
fi

printf -- "${is_demo}"
