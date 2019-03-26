## This is a different version of
##   URL: https://github.com/INWTlab/r-docker/blob/master/r-ver-ubuntu/Dockerfile
##   to be used for VMs instead of Docker images.

BUILD_DATE=${2:-"2018-07-30"}
R_VERSION=${1:-"3.5.1"}
# export LC_ALL="en_US.UTF-8"
# export LANG="en_US.UTF-8"

## R build dependencies
apt-get update
apt-get build-dep r-base
apt-get install \
        curl \
        libssl-dev \
        libxml2-dev \
        libssh2-1-dev \
        openjdk-8-jdk \
        libbz2-dev \
        liblzma-dev \
        libpcre3-dev \
        libpng-dev \
        libgdal-dev \
        libglu1-mesa-dev \
        freeglut3-dev \
        mesa-common-dev \
        sed \
        libpq-dev

# apt-get install libmysqlclient-dev

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
            --prefix=/usr/local/lib/R/${R_VERSION} \
            --disable-nls
## Build and install
make
make install
# -- Tests for R installation - should not be included into the final image --
# && make install-tests \
    # && cd /usr/local/lib/R/tests \
    # && ../bin/R CMD make check
# -- end --
## Add a library directory (for user-installed packages)
mkdir -p /usr/local/lib/R/${R_VERSION}/lib/R/site-library
## Set user library to version specific
sed -i "s/^R_LIBS_USER.*/R_LIBS_USER=\${R_LIBS_USER-'~\/R\/x86_64-pc-linux-gnu-library\/$R_VERSION'}/" /usr/local/lib/R/${R_VERSION}/lib/R/etc/Renviron
## install packages from date-locked MRAN snapshot of CRAN
[ -z "$BUILD_DATE" ] && BUILD_DATE=$(TZ="America/Los_Angeles" date -I) || true
MRAN=https://mran.microsoft.com/snapshot/${BUILD_DATE}
echo "options(repos = c(CRAN='$MRAN'), download.file.method = 'libcurl')" >> /usr/local/lib/R/${R_VERSION}/lib/R/etc/Rprofile.site

# Make this version the default
rm -vf /usr/local/bin/R
rm -vf /usr/local/bin/Rscript
ln -s /usr/local/lib/R/${R_VERSION}/lib/R/bin/R /usr/local/bin/R
ln -s /usr/local/lib/R/${R_VERSION}/lib/R/bin/Rscript /usr/local/bin/Rscript
# Make version available
ln -s /usr/local/lib/R/${R_VERSION}/lib/R/bin/R /usr/local/bin/R-${R_VERSION}
ln -s /usr/local/lib/R/${R_VERSION}/lib/R/bin/Rscript /usr/local/bin/Rscript-${R_VERSION}

# For R Java
R-${R_VERSION} CMD javareconf
# Update 'recommended' packages to be inline with MRAN
R-${R_VERSION} -e "update.packages(ask = FALSE)"

## Clean up from R source install
cd ~
rm -rf /tmp/R-${R_VERSION}
