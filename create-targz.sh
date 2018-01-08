#!/bin/bash

sudo debootstrap --make-tarball=install.tar.gz --arch=amd64 --force-check-gpg stretch stretch

