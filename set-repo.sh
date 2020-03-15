#!/bin/bash
# set repositories for your R versions
REPO=${REPO:-"https://inwt-vmeh2.inwt.de/r-repo"}
R_VERSION=/usr/local/bin/R-${1:-"3.5.2"}
R_VERSION_NAME=`basename $R_VERSION | cat | sed -r 's/^R-//g'`

echo "options(repos = c(getOption(\"repos\"), \"$REPO\"))" >> \
     /usr/local/lib/R/${R_VERSION_NAME}/lib/R/etc/Rprofile.site
