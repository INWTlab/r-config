FROM inwt/r-batch:3.6.0

RUN apt-get update && \
  apt-get install -y \
  dpkg-dev \
  debhelper-compat \
  lsb-release \
  apt-utils

WORKDIR /app

COPY deb-pkg/. .

CMD ["bash","build.sh"]
