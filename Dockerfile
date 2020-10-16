FROM ubuntu:focal

ADD . /tmp

WORKDIR /tmp

ENV REPO https://inwt-vmeh2.inwt.de/r-repo
ENV R_VERSION 3.6.0
ENV DEBIAN_FRONTEND noninteractive

RUN bash focal/install-r.sh ${R_VERSION} 2019-07-04
RUN bash set-first.sh ${R_VERSION}
RUN bash install-pkg.sh ${R_VERSION} tidyverse
RUN bash set-repo.sh ${R_VERSION}
RUN bash install-repo.sh ${R_VERSION}
RUN bash uninstall-repo.sh ${R_VERSION}
