#!/bin/bash
# install all packages from a repo for all your R-versions
REPO=${REPO:-"https://inwt-vmeh2.inwt.de/r-repo"}
R_VERSION=/usr/local/bin/R-${1:-"3.5.2"}

$R_VERSION -e "options(warn=2);install.packages(rownames(available.packages(repos = \"${REPO}\")), Ncpus = parallel::detectCores())"

