FROM ubuntu:eoan

RUN echo https://cran.r-project.org/bin/linux/ubuntu/ >> /etc/apt/sources.list

RUN apt-get update && \
  apt-get install -y \
  dpkg-dev \
  debhelper-compat \
  lsb-release \
  apt-utils \
  r-base=3.6.0

WORKDIR /app

COPY deb-pkg/. .

CMD ["bash","build.sh"]
