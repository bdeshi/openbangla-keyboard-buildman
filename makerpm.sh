#!/usr/bin/env bash
export DIST=$1
export RELPACK=$2
dnf install -y @buildsys-build cmake qt5-qtdeclarative-devel ibus-devel ninja-build
git clone https://github.com/OpenBangla/OpenBangla-Keyboard.git /repo
cmake -H/repo -B/build -GNinja -DCPACK_GENERATOR=RPM
ninja package -C build
curl --upload-file /build/${RELPACK}${DIST}.rpm "https://transfer.sh/OBK/${RELPACK}${DIST}.rpm"