#!/bin/bash
# install all packages from a repo for all your R-versions

REPO=${1:-"https://inwt-vmeh2.inwt.de/r-repo"}

for R_VERSION in `ls /usr/local/bin/R-* | cat`;
do
    $R_VERSION -e "install.packages(rownames(available.packages(repos = \"${REPO}\")))"
done

