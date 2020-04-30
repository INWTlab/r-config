#!/bin/bash

set -e

cd r-packages-deb

R_VERSION=${R_VERSION:-3.6.0}
MRAN_TIMESTAMP=${MRAN:-2019-12-12}
PACKAGE_VERSION=${PACKAGE_VERSION:-1.0.0}
UBUNTU_RELEASE=${UBUNTU_RELEASE:-eoan}

MRAN=https://mran.microsoft.com/snapshot/${MRAN_TIMESTAMP}

# dh_make -y \
#   --native \
#   --single \
#   --packagename r-$R_VERSION-packages_$PACKAGE_VERSION \
#   --email andreas.neudecker@inwt-statistics.de

# add r-3.6.0 as dependency to debian/control
# add debian/install: files/opt/* opt

# TODO: Update package version

mkdir -p files/opt/R/$R_VERSION/lib/x86_64-linux-gnu/R/library
Rscript installPackages.R $MRAN files/opt/R/$R_VERSION/lib/x86_64-linux-gnu/R/library

dpkg-buildpackage --no-sign

mkdir -p /tmp/deb-repo/$UBUNTU_RELEASE/amd64

mv ../*.deb /tmp/deb-repo/$UBUNTU_RELEASE/amd64

cd /tmp/deb-repo/$UBUNTU_RELEASE

apt-ftparchive --arch amd64 packages amd64 > Packages
gzip -k -f Packages

apt-ftparchive release . > Release

# sign Release file
gpg --import --passphrase-file ~/.gpg/passphrase \
    --batch --pinentry-mode loopback ~/.gpg/private.key

gpg -abs --passphrase-file ~/.gpg/pgp_passphrase -o Release.gpg \
    --batch --pinentry-mode loopback Release
