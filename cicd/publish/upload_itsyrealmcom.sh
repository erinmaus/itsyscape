#!/bin/sh

cd "$(dirname "$0")"

first_tag=$(git for-each-ref --sort=-creatordate --format '%(objectname)' refs/tags | sed -n 2p)
second_tag=$(git for-each-ref --sort=-creatordate --format '%(objectname)' refs/tags | sed -n 1p)

echo "Commit range: ${first_tag} .. ${second_tag}"

patch_notes=$(git log --pretty=format:"* %s" "${first_tag}..${second_tag}")

echo "Patch notes:\n${patch_notes}"

function get_csrf_token() {
	curl -b cookie.txt -c cookie.txt -s -f -L $1 | sed -n 's/.*<input id="csrf_token".*value="\(.*\)\">/\1/p'
}

curl \
	-b cookie.txt -c cookie.txt -s -f -o /dev/null -L \
	"https://itsyrealm.com/admin/login" \
	-F "username=${ITSYREALM_ADMIN_USERNAME}" \
	-F "password=${ITSYREALM_ADMIN_PASSWORD}" \
	-F "csrf_token=$(get_csrf_token 'https://itsyrealm.com/admin/login')"

if [ $? -ne 0 ]; then
	echo "Could not log in to ItsyRealm admin page."
	exit 1
fi

echo "Logged in to ItsyRealm admin page."

release_url=$(\
	curl \
		-b cookie.txt -c cookie.txt -s -L -o /dev/null -w '%{url_effective}' \
		-o /dev/null \
		"https://itsyrealm.com/admin/downloads/release/add" \
		-F "type=1" \
		-F "version_major=0" -F "version_minor=0" -F "version_revision=0" \
		-F "version_tag=0" \
		-F "patch_notes=${patch_notes}" \
		-F "csrf_token=$(get_csrf_token "https://itsyrealm.com/admin/downloads/release/add")"
)

if [ $? -ne 0 ]; then
	echo "Could not add new release."
	exit 1
fi

release_id=$(echo $release_url | sed -n 's/.*\/\([0-9][0-9]*\)$/\1/p')

if [ -z "${release_id}" ]; then
	echo "Could not parse new release."
	exit 1
fi

echo "Adding release ${release_id}..."

curl \
	-b cookie.txt -c cookie.txt -L -f -o /dev/null --progress-bar \
	"https://itsyrealm.com/admin/downloads/download/add/${release_id}" \
	-F "binary=@itsyrealm_windows.zip" \
	-F "platform=Win64" \
	-F "csrf_token=$(get_csrf_token "https://itsyrealm.com/admin/downloads/download/add/${release_id}")"

if [ $? -ne 0 ]; then
	echo "Could not upload Win64 build."
	exit 1
fi

echo "Uploaded Win64 build."

curl \
	-b cookie.txt -c cookie.txt -L -f -o /dev/null --progress-bar \
	"https://itsyrealm.com/admin/downloads/download/add/${release_id}" \
	-F "binary=@itsyrealm_macos.zip" \
	-F "platform=macOS" \
	-F "csrf_token=$(get_csrf_token "https://itsyrealm.com/admin/downloads/download/add/${release_id}")"

if [ $? -ne 0 ]; then
	echo "Could not upload macOS build."
	exit 1
fi

echo "Uploaded macOS build."

cd ./itsyrealm_linux && zip -v ../itsyrealm_linux_appimage.zip itsyrealm.AppImage && cd ..

curl \
	-b cookie.txt -c cookie.txt -L -f -o /dev/null --progress-bar \
	"https://itsyrealm.com/admin/downloads/download/add/${release_id}" \
	-F "binary=@itsyrealm_linux_appimage.zip" \
	-F "platform=Linux64" \
	-F "csrf_token=$(get_csrf_token "https://itsyrealm.com/admin/downloads/download/add/${release_id}")"

if [ $? -ne 0 ]; then
	echo "Could not upload Linux64 build."
	exit 1
fi

echo "Uploaded Linux64 build."

echo "Uploaded all builds."
