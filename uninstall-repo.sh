#!/bin/bash
# uninstall all packages from a repo
REPO=${REPO:-"https://inwt-vmeh2.inwt.de/r-repo"}
R_VERSION=/usr/local/bin/R-${1:-"3.5.2"}

$R_VERSION -e "remove.packages(rownames(available.packages(repos = \"${REPO}\")))"
