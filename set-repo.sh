#!/bin/bash
# set repositories for your R versions
REPO=${REPO:-"https://inwt-vmeh2.inwt.de/r-repo"}
R_VERSION=/usr/local/bin/R-${1:-"3.5.2"}
R_VERSION_NAME=`basename $R_VERSION | cat | sed -r 's/^R-//g'`
if [ -d /usr/local/lib/R/${R_VERSION_NAME}/lib ]; then
    R_LIB_FOLDER=lib
else
    R_LIB_FOLDER=lib64
fi

echo "options(repos = c(getOption(\"repos\"), \"$REPO\"))" >> \
     /usr/local/lib/R/${R_VERSION_NAME}/${R_LIB_FOLDER}/R/etc/Rprofile.site
