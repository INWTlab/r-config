#!/bin/bash
# install a R-package for all your R-versions
R_VERSION=/usr/local/bin/R-${1:-"4.0.2"}
PKG=${2:-""}
$R_VERSION -e "options(warn=2);install.packages(\"${PKG}\", Ncpus = parallel::detectCores())"
