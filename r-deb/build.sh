#!/bin/bash

set -e

R_VERSION=3.6.0
PACKAGE_VERSION=1.0.2
PACKAGE_NAME=r-${R_VERSION}
PACKAGE_NAME_FULL=${PACKAGE_NAME}_$PACKAGE_VERSION
curl -O https://cran.rstudio.com/src/base/R-3/R-${R_VERSION}.tar.gz
tar -xzvf R-${R_VERSION}.tar.gz
cd R-${R_VERSION}

dh_make --native \
  --single \
  --packagename $PACKAGE_NAME_FULL \
  --email andreas.neudecker@inwt-statistics.de \
  -f ../R-${R_VERSION}.tar.gz \
  -y

# custom configuration for r package
echo /opt/R/$R_VERSION/bin/R usr/local/bin/R-$R_VERSION >> debian/$PACKAGE_NAME.links
echo /opt/R/$R_VERSION/bin/Rscript usr/local/bin/Rscript-$R_VERSION >> debian/$PACKAGE_NAME.links
cat ../Rprofile >> src/library/profile/Rprofile.unix
sed -i '22 a AC_CONFIG_MACRO_DIR([m4])' configure.ac
sed -i "s/.*override_dh_auto_configure:.*/override_dh_auto_configure:/" debian/rules
sed -i "s/.*dh_auto_configure --.*/\tdh_auto_configure -- --prefix=\/opt\/R\/${R_VERSION}/" debian/rules

# end custom configuration

RELEASE=$(lsb_release -sc)

dpkg-buildpackage --no-sign

mkdir -p /tmp/deb-repo/amd64

mv ../*.deb /tmp/deb-repo/amd64

cd /tmp/deb-repo

apt-ftparchive --arch amd64 packages amd64 > Packages
gzip -k -f Packages

apt-ftparchive release . > Release
