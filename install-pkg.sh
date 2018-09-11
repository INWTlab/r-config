#!/bin/bash
# install a R-package for all your R-versions
PKG=${1:-""}

for R_VERSION in `ls /usr/local/bin/R-* | cat`;
do
    $R_VERSION -e "install.packages(\"${PKG}\")"
done
