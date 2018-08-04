#!/bin/bash

set -e

BUILDIR=$(pwd)
TMPDIR=$(mktemp -d)

ARCH="amd64"
DIST="stretch"

cd $TMPDIR

sudo cdebootstrap -a $ARCH --include=sudo,locales $DIST $DIST http://deb.debian.org/debian

sudo chroot $DIST apt-get clean

sudo chroot $DIST /bin/bash -c "update-locale LANGUAGE=en_US.UTF-8 LC_ALL=C"

sudo chroot $DIST /bin/bash -c "echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen"

sudo cp $BUILDIR/linux_files/profile $TMPDIR/$DIST/etc/profile

sudo cp $BUILDIR/linux_files/sources.list $TMPDIR/$DIST/etc/apt/sources.list

cd $DIST

sudo tar --ignore-failed-read -czvf $TMPDIR/install.tar.gz *

cp $TMPDIR/install.tar.gz $BUILDIR

cd $BUILDIR

