#!/bin/bash

# NOTE: you need to have the following packages installed for this to work:
# sudo apt install qemu-user-static binfmt-support debootstrap
#
# Based on: https://learn.microsoft.com/en-us/windows/wsl/build-custom-distro#configuration-file-recommendations

set -e

BUILDIR=$(pwd)

mkdir -p $BUILDIR/rootfs
mkdir -p $BUILDIR/debcache

TMPDIR=$(mktemp -d -p $BUILDIR/rootfs)
TMPDIR_ARM64=$(mktemp -d -p $BUILDIR/rootfs)

DIST="trixie"

create_x64_rootfs() {
	cd $TMPDIR

	sudo debootstrap --arch "amd64" --cache-dir=$BUILDIR/debcache --exclude=debfoster --include=sudo,locales,libpam-systemd,dbus $DIST $DIST http://deb.debian.org/debian
	sudo chroot $DIST apt-get clean
	sudo chroot $DIST /bin/bash -c "echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen"
	sudo chroot $DIST /bin/bash -c "update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8"
	sudo cp $BUILDIR/linux_files/profile $TMPDIR/$DIST/etc/profile
	sudo cp $BUILDIR/linux_files/sources.list $TMPDIR/$DIST/etc/apt/sources.list
	sudo cp $BUILDIR/linux_files/wsl-distribution.conf $TMPDIR/$DIST/etc/wsl-distribution.conf
	sudo cp $BUILDIR/linux_files/wsl.conf $TMPDIR/$DIST/etc/wsl.conf
	sudo mkdir -p $TMPDIR/$DIST/usr/lib/wsl/
	sudo cp $BUILDIR/linux_files/oobe.sh $TMPDIR/$DIST/usr/lib/wsl/oobe.sh
	sudo chmod 755 $TMPDIR/$DIST/usr/lib/wsl/oobe.sh
	sudo cp $BUILDIR/pictures/debian_logo.ico $TMPDIR/$DIST/usr/lib/wsl/debian_logo.ico
	sudo rm -f $TMPDIR/$DIST/etc/resolv.conf

	cd $DIST
	sudo tar --numeric-owner --absolute-names --ignore-failed-read -czvf $TMPDIR/install.tar.gz *

	mkdir -p $BUILDIR/x64
	mv -f $TMPDIR/install.tar.gz $BUILDIR/x64/install.tar.gz

	sha=($(shasum -a 256 $BUILDIR/x64/install.tar.gz))
	echo $sha > $BUILDIR/x64/install.tar.gz.sha256sum

	cd $BUILDIR
}

create_arm64_rootfs() {
	cd $TMPDIR_ARM64

	sudo debootstrap --arch "arm64" --cache-dir=$BUILDIR/debcache --foreign --exclude=debfoster --include=sudo,locales,libpam-systemd,dbus $DIST $DIST http://deb.debian.org/debian
	sudo cp $(which qemu-aarch64-static) $DIST/usr/bin
	sudo chroot $DIST /debootstrap/debootstrap --second-stage
	sudo chroot $DIST apt-get clean
	sudo chroot $DIST /bin/bash -c "echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen"
	sudo chroot $DIST /bin/bash -c "update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8"
	sudo rm -f $TMPDIR_ARM64/$DIST/usr/bin/qemu-aarch64-static
	sudo cp $BUILDIR/linux_files/profile $TMPDIR_ARM64/$DIST/etc/profile
	sudo cp $BUILDIR/linux_files/sources.list $TMPDIR_ARM64/$DIST/etc/apt/sources.list
	sudo cp $BUILDIR/linux_files/wsl-distribution.conf $TMPDIR_ARM64/$DIST/etc/wsl-distribution.conf
	sudo cp $BUILDIR/linux_files/wsl.conf $TMPDIR_ARM64/$DIST/etc/wsl.conf
	sudo mkdir -p $TMPDIR_ARM64/$DIST/usr/lib/wsl/
	sudo cp $BUILDIR/linux_files/oobe.sh $TMPDIR_ARM64/$DIST/usr/lib/wsl/oobe.sh
	sudo chmod 755 $TMPDIR_ARM64/$DIST/usr/lib/wsl/oobe.sh
	sudo cp $BUILDIR/pictures/debian_logo.ico $TMPDIR_ARM64/$DIST/usr/lib/wsl/debian_logo.ico
	sudo rm -f $TMPDIR_ARM64/$DIST/etc/resolv.conf

	cd $DIST
	sudo tar --numeric-owner --absolute-names --ignore-failed-read -czvf $TMPDIR_ARM64/install_arm64.tar.gz *

	mkdir -p $BUILDIR/ARM64
	mv -f $TMPDIR_ARM64/install_arm64.tar.gz $BUILDIR/ARM64/install.tar.gz

	sha=($(shasum -a 256 $BUILDIR/ARM64/install.tar.gz))
	echo $sha > $BUILDIR/ARM64/install.tar.gz.sha256sum

	cd $BUILDIR
}

create_x64_rootfs
create_arm64_rootfs
