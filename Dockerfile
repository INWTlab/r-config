FROM ubuntu:eoan

RUN apt-get update && \
  apt-get install -y \
  dpkg-dev \
  debhelper-compat \
  lsb-release \
  apt-utils

WORKDIR /app

COPY deb-pkg/. .

CMD ["bash","build.sh"]
