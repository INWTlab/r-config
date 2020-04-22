#!/bin/bash

set -e

RELEASE=$(lsb_release -sc)

dpkg-buildpackage --no-sign

mkdir -p /tmp/deb-repo/pool/main/n \
      /tmp/deb-repo/dists/$RELEASE/main/binary-{amd64,i386}

mv ../*.deb /tmp/deb-repo/pool/main/n

dpkg-scanpackages -m /tmp/deb-repo/pool | gzip > \
  /tmp/deb-repo/dists/$RELEASE/main/binary-amd64/Packages.gz
