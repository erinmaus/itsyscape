#!/bin/sh

cd "$(dirname "$0")"

if [ -z "$ITSYREALM_META_VERSION" ]; then
    ITSYREALM_META_VERSION="$(./make_version.sh)"
fi

echo "Make version.meta for ${ITSYREALM_META_VERSION}..."

printf -- "$ITSYREALM_META_VERSION" > "../../itsyscape/version.meta"

cat "../../itsyscape/version.meta"
echo
