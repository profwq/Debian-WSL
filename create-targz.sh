#!/bin/bash

BUILDIR=$(pwd)

cd /tmp

sudo debootstrap --arch=amd64 --force-check-gpg stretch stretch

sudo chroot stretch apt-get clean

cd /tmp/stretch

tar czvf /tmp/install.tar.gz .

cp /tmp/install.tar.gz $BUILDIR

cd $BUILDIR

