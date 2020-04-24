#!/bin/bash

set -e

R_VERSION=3.6.0
MRAN=https://mran.microsoft.com/snapshot/2019-12-12
# PACKAGE_VERSION=1.0.0

# dh_make -y \
#   --native \
#   --single \
#   --packagename r-$R_VERSION-packages_$PACKAGE_VERSION \
#   --email andreas.neudecker@inwt-statistics.de

# add r-3.6.0 as dependency to debian/control
# add debian/install: files/opt/* opt

mkdir -p files/opt/R/3.6.0/lib/x86_64-linux-gnu/R/library
Rscript installPackages.R $MRAN files/opt/R/3.6.0/lib/x86_64-linux-gnu/R/library

RELEASE=$(lsb_release -sc)

dpkg-buildpackage --no-sign

mkdir -p /tmp/deb-repo/amd64

mv ../*.deb /tmp/deb-repo/amd64

cd /tmp/deb-repo

apt-ftparchive --arch amd64 packages amd64 > Packages
gzip -k -f Packages

apt-ftparchive release . > Release
