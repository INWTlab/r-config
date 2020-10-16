#!/bin/bash
# set .First in Rprofile.site for all your R versions
R_VERSION=/usr/local/bin/${1:-"R-4.0.2"}
R_VERSION_NAME=`basename $R_VERSION | cat | sed -r 's/^R-//g'`
if [ -d /usr/local/lib/R/${R_VERSION_NAME}/lib ]; then
    R_LIB_FOLDER=lib
else
    R_LIB_FOLDER=lib64
fi

RPROFILE=/usr/local/lib/R/${R_VERSION_NAME}/$R_LIB_FOLDER/R/etc/Rprofile.site
echo "Appending to $RPROFILE"
echo ".First <- function() {"                                          >> $RPROFILE
echo "  if (!interactive()) return(invisible(NULL))"                   >> $RPROFILE
echo "  cat(\"Repos are set to:\n\")"                                  >> $RPROFILE
echo "  for (repo in getOption(\"repos\")) cat(\"  -\", repo, \"\n\")" >> $RPROFILE
echo "  cat(\"Library paths are set to:\n\")"                          >> $RPROFILE
echo "  for (lib in .libPaths()) cat(\"  -\", lib, \"\n\")"            >> $RPROFILE
echo "}"                                                               >> $RPROFILE
echo "NEW Rprofile.site"
cat $RPROFILE
