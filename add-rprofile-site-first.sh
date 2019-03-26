#!/bin/bash
# add .First function to Rprofile.site
echo "Deprecated: use set-first.sh"

R_VERSION=${1:-"3.5.1"}
RPROFILE=/usr/local/lib/R/${R_VERSION}/lib/R/etc/Rprofile.site
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
