FROM ubuntu:eoan

RUN apt-get update && \
  apt-get install -y \
  dpkg-dev \
  debhelper-compat \
  lsb-release

WORKDIR /app

COPY deb-pkg/. .

CMD ["bash","build.sh"]
