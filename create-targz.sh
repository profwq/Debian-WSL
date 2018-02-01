#!/bin/bash

set -e

BUILDIR=$(pwd)
TMPDIR=$(mktemp -d)

ARCH="amd64"
DIST="stretch"

cd $TMPDIR

#sudo debootstrap --arch=$ARCH --force-check-gpg --variant=minbase --include=sudo $DIST $DIST
sudo cdebootstrap -a $ARCH --include=sudo $DIST $DIST http://ftp.de.debian.org/debian

sudo chroot $DIST apt-get clean

cd $DIST

tar --ignore-failed-read -czvf $TMPDIR/install.tar.gz .

cp $TMPDIR/install.tar.gz $BUILDIR

cd $BUILDIR

