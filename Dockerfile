FROM ubuntu:eoan

RUN sed -i 's_# deb-src http://archive.ubuntu.com/ubuntu/ eoan universe_deb-src http://archive.ubuntu.com/ubuntu/ eoan universe_' /etc/apt/sources.list

ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Berlin

RUN apt-get update && \
  apt-get install -y \
  dpkg-dev \
  debhelper-compat \
  lsb-release \
  apt-utils \
  dh-make && \
  apt-get build-dep -y r-base

# install specific R version
ENV R_VERSION=3.6.0

RUN curl -O https://cran.rstudio.com/src/base/R-3/R-${R_VERSION}.tar.gz && \
  tar -xzvf R-${R_VERSION}.tar.gz && \
  cd R-${R_VERSION} && \
  ./configure \
  --prefix=/opt/R/${R_VERSION} \
  --enable-memory-profiling \
  --enable-R-shlib \
  --with-blas \
  --with-lapack && \
  make && \
  make install

# dependencies for R packages
RUN apt-get install -y \
  libssl-dev # openssl

WORKDIR /app

COPY deb-pkg/. .

CMD ["bash","build.sh"]
