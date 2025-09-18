#!/bin/sh

set -xe

file "$ITSYREALM_IOS_PROFILE_FILENAME"

provisioning_profile_uuid=$(/usr/libexec/PlistBuddy -c 'Print :UUID' /dev/stdin <<< $(security cms -D -i "$ITSYREALM_IOS_PROFILE_FILENAME"))

cp "$ITSYREALM_IOS_PROFILE_FILENAME" "$HOME/Library/MobileDevice/Provisioning Profiles/${provisioning_profile_uuid}.mobileprovision"

ls -l "$HOME/Library/MobileDevice/Provisioning Profiles/"