export IOS_PROFILE_NAME=$IOS_PROFILE_NAME_BUILD
export IOS_PROFILE_FILENAME=$IOS_PROFILE_FILENAME_BUILD
export IOS_CERTIFICATE_NAME=$IOS_CERTIFICATE_NAME_BUILD
export LOVE_BINARY=/Users/erinmaus/Code/ItsyRealm/itsyscape/cicd/ios/../macos/staging/ItsyRealm.app/Contents/MacOS/ItsyRealm 

cd ./cicd/ios
./zip_itsyrealm.sh
./package.sh

xcrun devicectl device install app --device $IPAD_UUID itsyrealm/ItsyRealm.ipa
xcrun devicectl device process launch --device $IPAD_UUID com.itsyrealm
