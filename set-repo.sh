#!/bin/bash
# set repositories for your R versions
REPO=${1:-"https://inwt-vmeh2.inwt.de/r-repo"}

for R_VERSION in `ls /usr/local/bin/R-* | cat`;
do
    R_VERSION_NAME=`basename $R_VERSION | cat | sed -r 's/^R-//g'`
    echo "options(repos = c(options(\"repos\"), \"$REPO\"))" >> /usr/local/lib/R/${R_VERSION_NAME}/lib/R/etc/Rprofile.site
done
