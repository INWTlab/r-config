FROM ubuntu:eoan

ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Berlin

RUN apt-get update && \
  apt-get install -y \
  dpkg-dev \
  debhelper-compat \
  lsb-release \
  apt-utils \
  ca-certificates \
  gnupg2
  r-base=3.6.0

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
  echo deb https://cran.r-project.org/bin/linux/ubuntu/ eoan-cran35/ >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y r-base=3.6.1-7eoan r-recommended=3.6.1-7eoan r-base-html r-doc-html

WORKDIR /app

COPY deb-pkg/. .

CMD ["bash","build.sh"]
