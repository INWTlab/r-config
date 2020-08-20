#!/bin/bash

set -e

cd r-deb

R_VERSION=${R_VERSION:-3.6.0}
MRAN_TIMESTAMP=${MRAN:-2019-12-12}
PACKAGE_VERSION=${PACKAGE_VERSION:-1.0.0}
UBUNTU_RELEASE=${UBUNTU_RELEASE:-eoan}

MRAN=https://mran.microsoft.com/snapshot/${MRAN_TIMESTAMP}
PACKAGE_NAME=r-${R_VERSION}
PACKAGE_NAME_FULL=${PACKAGE_NAME}_$PACKAGE_VERSION

curl -O https://cran.rstudio.com/src/base/R-4/R-${R_VERSION}.tar.gz
tar -xzf R-${R_VERSION}.tar.gz
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
sed -i 's/MRAN_TIMESTAMP/'"$MRAN_TIMESTAMP"'/' ../Rprofile
cat ../Rprofile >> src/library/profile/Rprofile.unix
sed -i '22 a AC_CONFIG_MACRO_DIR([m4])' configure.ac
sed -i "s/.*override_dh_auto_configure:.*/override_dh_auto_configure:/" debian/rules
sed -i "s/.*dh_auto_configure --.*/\tdh_auto_configure -- --prefix=\/opt\/R\/${R_VERSION} --enable-R-shlib --enable-memory-profiling --with-readline --with-blas --with-lapack --with-tcltk --disable-nls/" debian/rules

export R_PAPERSIZE=letter
export R_BATCHSAVE="--no-save --no-restore"
export R_BROWSER=xdg-open
export PAGER=/usr/bin/pager
export PERL=/usr/bin/perl
export R_UNZIPCMD=/usr/bin/unzip
export R_ZIPCMD=/usr/bin/zip
export R_PRINTCMD=/usr/bin/lpr
export LIBnn=lib
export AWK=/usr/bin/awk
export CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g"
export CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g"
# end custom configuration

dpkg-buildpackage --no-sign

mkdir -p /tmp/deb-repo/$UBUNTU_RELEASE/amd64

mv ../*.deb /tmp/deb-repo/$UBUNTU_RELEASE/amd64

cd /tmp/deb-repo/$UBUNTU_RELEASE

apt-ftparchive --arch amd64 packages amd64 > Packages
gzip -k -f Packages

apt-ftparchive release . > Release

# sign Release file
gpg --import --yes --passphrase-file ~/.gpg/passphrase \
    --batch --pinentry-mode loopback ~/.gpg/private.key

gpg -abs --yes --passphrase-file ~/.gpg/passphrase -o Release.gpg \
    --batch --pinentry-mode loopback Release

gpg --yes --passphrase-file ~/.gpg/passphrase \
    --batch --pinentry-mode loopback \
    --clearsign -o InRelease Release

gpg --output KEY.gpg --armor --export --yes
