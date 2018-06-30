#!/usr/bin/env bash
export DIST=$1
export RELPACK=$2
export RELVER=$3
export DEPLOY=$4
pacman -S --noconfirm --needed base-devel cmake libibus qt5-base curl
mkdir /build
cd /build
echo -e "pkgver=\"$RELVER\"\n$(cat /ci/PKGBUILD.stub)" > PKGBUILD
# makepkg does not run as root
chown nobody:nobody /build
sudo -u nobody makepkg -fd --skipinteg
mv openbangla-keyboard-*.pkg.tar.xz ${RELPACK}${DIST}.pkg.tar.xz
if [ $DEPLOY == 1 ]; then
    echo "Deploying artifacts to transfer.sh"
    curl --upload-file ${RELPACK}${DIST}.pkg.tar.xz https://transfer.sh/${RELPACK}${DIST}.pkg.tar.xz
fi