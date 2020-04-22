#!/bin/bash

set -e

RELEASE=$(lsb_release -sc)

dpkg-buildpackage --no-sign

mkdir -p /tmp/deb-repo/amd64

mv ../*.deb /tmp/deb-repo/amd64

cd /tmp/deb-repo

apt-ftparchive --arch amd64 packages amd64 > Packages
gzip -k -f Packages

apt-ftparchive release . > Release
