#!/bin/sh

set -xe

file=$(basename -- $1)
name="${file%.*}"
extension="${file##*.}"

FRAMEWORK_PATH=./Payload/ItsyRealm.app/Frameworks/${name}.framework

mkdir -p ${FRAMEWORK_PATH}
cp ../plist/${name}.plist ${FRAMEWORK_PATH}/Info.plist
sed -i '' "s/com.itsyrealm/com.itsyrealm.${name}/g" ${FRAMEWORK_PATH}/Info.plist
plutil -convert binary1 ${FRAMEWORK_PATH}/Info.plist
lipo $1 -output ${FRAMEWORK_PATH}/${name} -create

ls -la ${FRAMEWORK_PATH}
