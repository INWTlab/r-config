#!/bin/bash
# set .First in Rprofile.site for all your R versions
for R_VERSION in `ls /usr/local/bin/R-* | cat`;
do
    R_VERSION_NAME=`basename $R_VERSION | cat | sed -r 's/^R-//g'`
    bash add-rprofile-site-first.sh $R_VERSION_NAME
done
