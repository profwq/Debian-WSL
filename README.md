# Debian WSL DistroLauncher

as of March 2018 the first version of the Debian app for the Windows Subsystem
for Linux (WSL) is available in the Windows store.

This repository contains all build files for the launcher itself and the scripts
necessary to build the install.tar.gz root file system needed by the WSL api.

# Contact / Feedback

There is a IRC channel on OFTC to get in touch: #debian-wsl

User information are available in the debian wiki:

https://wiki.debian.org/InstallingDebianOn/Microsoft/Windows/SubsystemForLinux

# Building

to build the solution file you will need a Windows development environment with
a working Visual Studio 2017 UWP installation.

Prior to building the solution you have to provide a install.tar.gz file
containing a debian root file system. have a look at the `create-targz.sh`
script to get an idea of how this works.

# License

The original launcher code is licensed by Microsoft Corporation under the MIT License.

To keep things compatible I will use the same LICENSE for my derivative work.
