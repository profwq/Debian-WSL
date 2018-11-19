#!/bin/bash

set -e

BUILDIR=$(pwd)
TMPDIR=$(mktemp -d)
TMPDIR_ARM64=$(mktemp -d)

DIST="stretch"

create_x64_rootfs () {
    cd $TMPDIR

    sudo cdebootstrap -a "amd64" --include=sudo,locales $DIST $DIST http://deb.debian.org/debian
    sudo chroot $DIST apt-get clean
    sudo chroot $DIST /bin/bash -c "update-locale LANGUAGE=en_US.UTF-8 LC_ALL=C"
    sudo chroot $DIST /bin/bash -c "echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen"
    sudo cp $BUILDIR/linux_files/profile $TMPDIR/$DIST/etc/profile
    sudo cp $BUILDIR/linux_files/sources.list $TMPDIR/$DIST/etc/apt/sources.list

    cd $DIST
    sudo tar --ignore-failed-read -czvf $TMPDIR/install.tar.gz *

    mkdir -p $BUILDIR/x64
    mv $TMPDIR/install.tar.gz $BUILDIR/x64
    cd $BUILDIR
}


create_arm64_rootfs () {
    cd $TMPDIR_ARM64

    sudo cdebootstrap -a "arm64" --foreign --include=sudo,locales $DIST $DIST http://deb.debian.org/debian
    sudo chroot $DIST apt-get clean
    sudo chroot $DIST /bin/bash -c "update-locale LANGUAGE=en_US.UTF-8 LC_ALL=C"
    sudo chroot $DIST /bin/bash -c "echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen"
    sudo cp $BUILDIR/linux_files/profile $TMPDIR_ARM64/$DIST/etc/profile
    sudo cp $BUILDIR/linux_files/sources.list $TMPDIR_ARM64/$DIST/etc/apt/sources.list

    cd $DIST
    sudo tar --ignore-failed-read -czvf $TMPDIR_ARM64/install_arm64.tar.gz *

    mkdir -p $BUILDIR/ARM64
    mv $TMPDIR_ARM64/install_arm64.tar.gz $BUILDIR/ARM64/install.tar.gz
    cd $BUILDIR
}

create_x64_rootfs
create_arm64_rootfs
