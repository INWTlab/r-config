## This is a different version of
##   URL: https://github.com/INWTlab/r-docker/blob/master/r-ver-ubuntu/Dockerfile
##   to be used for VMs instead of Docker images.

BUILD_DATE="2018-07-30"
R_VERSION="3.5.1"
# export LC_ALL="en_US.UTF-8"
# export LANG="en_US.UTF-8"

## R build dependencies
sudo apt-get build-dep r-base
## -- BUILD R --
cd /tmp/
## Download source code
curl -O https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz
## Extract source code
tar -xf R-${R_VERSION}.tar.gz
cd R-${R_VERSION}
## Set compiler flags
R_PAPERSIZE=letter
R_BATCHSAVE="--no-save --no-restore"
R_BROWSER=xdg-open
PAGER=/usr/bin/pager
PERL=/usr/bin/perl
R_UNZIPCMD=/usr/bin/unzip
R_ZIPCMD=/usr/bin/zip
R_PRINTCMD=/usr/bin/lpr
LIBnn=lib
AWK=/usr/bin/awk
CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g"
CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g"
## Configure options
./configure --enable-R-shlib \
            --enable-memory-profiling \
            --with-readline \
            --with-blas \
            --with-lapack \
            --with-tcltk \
            --prefix=/usr/local/lib/R/${R_VERSION}
#            --disable-nls \
#            --without-recommended-packages \
## Build and install
make
sudo make install
# -- Tests for R installation - should not be included into the final image --
# && make install-tests \
    # && cd /usr/local/lib/R/tests \
    # && ../bin/R CMD make check
# -- end --
## Add a library directory (for user-installed packages)
sudo mkdir -p /usr/local/lib/R/${R_VERSION}/lib/R/site-library
## Fix library path
echo "R_LIBS_USER=\${R_LIBS_USER-'~/R/x86_64-pc-linux-gnu-library/${R_VERSION}'}" >> /usr/local/lib/R/${R_VERSION}/lib/R/etc/Renviron
echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/${R_VERSION}/lib/R/site-library:/usr/local/lib/R/${R_VERSION}/lib/R/library'}" >> /usr/local/lib/R/${R_VERSION}/lib/R/etc/Renviron
## install packages from date-locked MRAN snapshot of CRAN
[ -z "$BUILD_DATE" ] && BUILD_DATE=$(TZ="America/Los_Angeles" date -I) || true
MRAN=https://mran.microsoft.com/snapshot/${BUILD_DATE}
sudo echo "options(repos = c(CRAN='$MRAN'), download.file.method = 'libcurl')" >> /usr/local/lib/R/${R_VERSION}/lib/R/etc/Rprofile.site

# Make this version the default
sudo ln -s /usr/local/lib/R/${R_VERSION}/lib/R/bin/R /usr/local/bin/R
sudo ln -s /usr/local/lib/R/${R_VERSION}/lib/R/bin/Rscript /usr/local/bin/Rscript
# Make version available
sudo ln -s /usr/local/lib/R/${R_VERSION}/lib/R/bin/R /usr/local/bin/R-${R_VERSION}
sudo ln -s /usr/local/lib/R/${R_VERSION}/lib/R/bin/Rscript /usr/local/bin/Rscript-${R_VERSION}

## Clean up from R source install
cd ~
rm -rf /tmp/R-${R_VERSION}
