#!/bin/bash
# install a R-package for all your R-versions
R_VERSION=/usr/local/bin/R-${1:-"3.5.2"}
PKG=${2:-""}
$R_VERSION -e "install.packages(\"${PKG}\")"
