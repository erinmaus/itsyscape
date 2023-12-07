
#!/bin/sh

set -xe

export ITSYREALM_VERSION=$(../common/make_version.sh)
echo "Building ItsyRealm ${ITSYREALM_VERSION}"

git config --global core.autocrlf true

export PATH=/mingw64/bin:$PATH
export MINGW_ROOT=/mingw64
export MAKEFLAGS="-j4"

mkdir -p bin
mkdir -p build
mkdir -p staging/ext

./get_love.sh
./get_premake5.sh
./get_luajit.sh
./get_luahttps.sh
./get_sentry.sh
./get_discord.sh
./get_bmashina.sh
./get_discworld.sh
./get_nbunny.sh
./get_devi.sh
./zip_itsyrealm.sh

cp /mingw64/bin/libgcc_s_seh-1.dll ./staging/libgcc_s_seh-1.dll
cp /mingw64/bin/libwinpthread-1.dll ./staging/libwinpthread-1.dll
cp /mingw64/bin/libstdc++-6.dll ./staging/libstdc++-6.dll
cp /mingw64/bin/libstdc++-6.dll ./staging/libstdc++-6.dll
cp /mingw64/bin/libbz2-1.dll ./staging/libbz2-1.dll

cp -r staging itsyrealm
