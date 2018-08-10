## This is a different version of
##   URL: https://github.com/INWTlab/r-docker/blob/master/r-ver-ubuntu/Dockerfile
##   to be used for VMs instead of Docker images.

export BUILD_DATE="2018-07-30"
export R_VERSION="3.5.1"
# export LC_ALL="en_US.UTF-8"
# export LANG="en_US.UTF-8"

sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    bash-completion \
    ca-certificates \
    file \
    fonts-texgyre \
    g++ \
    gfortran \
    gsfonts \
    libblas-dev \
    libbz2-1.0 \
    libcurl3 \
    libicu60 \
    libjpeg62 \
    libopenblas-dev \
    libpangocairo-1.0-0 \
    libpcre3 \
    libpng16-16 \
    libreadline7 \
    libtiff5 \
    liblzma5 \
    locales \
    make \
    unzip \
    zip \
    zlib1g
  ## -- --
  # && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  # && locale-gen en_US.utf8 \
  # && /usr/sbin/update-locale LANG=en_US.UTF-8 \
BUILDDEPS="curl \
    default-jdk \
    libbz2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libicu-dev \
    libpcre3-dev \
    libpng-dev \
    libreadline-dev \
    libtiff5-dev \
    liblzma-dev \
    libx11-dev \
    libxt-dev \
    perl \
    tcl8.6-dev \
    tk8.6-dev \
    texinfo \
    texlive-extra-utils \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-recommended \
    x11proto-core-dev \
    xauth \
    xfonts-base \
    xvfb \
    zlib1g-dev" \
    && sudo apt-get install -y --no-install-recommends $BUILDDEPS
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
            --disable-nls \
            --without-recommended-packages \
            --prefix=/usr/local/R-${R_VERSION}
## Build and install
make
sudo make install
# -- Tests for R installation - should not be included into the final image --
# && make install-tests \
    # && cd /usr/local/lib/R/tests \
    # && ../bin/R CMD make check
# -- end --
## Add a library directory (for user-installed packages)
sudo mkdir -p /usr/local/lib/R-${R_VERSION}/site-library
sudo chown root:staff /usr/local/lib/R-${R_VERSION}/site-library
sudo chmod g+wx /usr/local/lib/R-${R_VERSION}/site-library
## Fix library path
echo "R_LIBS_USER='/usr/local/lib/R-${R_VERSION}/site-library'" >> /usr/local/lib/R-${R_VERSION}/etc/Renviron \
     echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R-${R_VERSION}/site-library:/usr/local/lib/R-${R_VERSION}/library:/usr/lib/R/library'}" >> /usr/local/lib/R-${R_VERSION}/etc/Renviron
## install packages from date-locked MRAN snapshot of CRAN
[ -z "$BUILD_DATE" ] && BUILD_DATE=$(TZ="America/Los_Angeles" date -I) || true
MRAN=https://mran.microsoft.com/snapshot/${BUILD_DATE}
sudo echo MRAN=$MRAN >> /etc/environment
export MRAN=$MRAN
sudo echo "options(repos = c(CRAN='$MRAN'), download.file.method = 'libcurl')" >> /usr/local/lib/R-${R_VERSION}/etc/Rprofile.site
## Clean up from R source install
cd ~
rm -rf /tmp/R-${R_VERSION}
