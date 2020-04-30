FROM ubuntu:eoan

## settings

ENV R_VERSION=3.6.0
ENV MRAN_TIMESTAMP=2019-12-12
ENV PACKAGE_VERSION=0.1.0
ENV UBUNTU_RELEASE=eoan
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin
ENV HOME=/app
WORKDIR /app

## end of settings

RUN sed -i 's_# deb-src http://archive.ubuntu.com/ubuntu/ eoan universe_deb-src http://archive.ubuntu.com/ubuntu/ eoan universe_' /etc/apt/sources.list

RUN apt-get update && \
  apt-get install -y \
  dpkg-dev \
  debhelper-compat \
  lsb-release \
  apt-utils \
  dh-make && \
  apt-get build-dep -y r-base


RUN curl -O https://cran.rstudio.com/src/base/R-3/R-${R_VERSION}.tar.gz && \
  tar -xzf R-${R_VERSION}.tar.gz && \
  cd R-${R_VERSION} && \
  ./configure \
  --enable-memory-profiling \
  --enable-R-shlib \
  --with-blas \
  --with-lapack && \
  make && \
  make install

# dependencies for R packages
RUN apt-get install -y \
  libssl-dev # openssl

COPY r-deb r-deb

COPY r-packages-deb r-packages-deb

CMD ["bash","r-deb/build.sh"]
