#! /bin/bash
# Always change this on every release
export RELVER=$(cat "`dirname $0`/version.txt")
export RELPACK="OpenBangla-Keyboard_$RELVER-"
# Check if we want to deploy build artifacts
string='deploy+'
export DEPLOY=$(git log -1 --pretty=%B | grep "$string" -q  && echo 1 || echo 0)

export REPO=${TRAVIS_PULL_REQUEST_SLUG:-$TRAVIS_REPO_SLUG}
export BRANCH=${TRAVIS_PULL_REQUEST_BRANCH:-$TRAVIS_BRANCH}

makeDeb() {
    docker exec build apt-get -qq update
    docker exec build apt-get -y install git
    docker exec build git clone https://github.com/$REPO.git -b $BRANCH /ci
    docker exec build /ci/makedeb.sh $DIST $RELPACK $DEPLOY
}

if [[ $DIST = "ubuntu16.04" ]]; then
    docker pull ubuntu:16.04
    docker run -itd --name build ubuntu:16.04
    makeDeb
elif [[ $DIST = "ubuntu18.04" ]]; then
    docker pull ubuntu:18.04
    docker run -itd --name build ubuntu:18.04
    makeDeb
elif [[ $DIST = "fedora28" ]]; then
    docker pull fedora:28
    docker run -itd --name build fedora:28 /bin/bash
    docker exec build dnf -y install git
    docker exec build git clone https://github.com/$REPO.git -b $BRANCH /ci
    docker exec build /ci/makerpm.sh $DIST $RELPACK $DEPLOY
elif [[ $DIST = "archlinux" ]]; then
    docker pull archlinux/base
    docker run -itd --name build archlinux/base
    docker exec build pacman -Syyu --noconfirm --needed
    docker exec build pacman -S --noconfirm --needed base git
    docker exec build git clone https://github.com/$REPO.git -b $BRANCH /ci
    docker exec build /ci/makearch.sh $DIST $RELPACK $RELVER $DEPLOY
fi
