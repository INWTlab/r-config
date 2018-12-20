#!/bin/bash
# add .First function to Rprofile.site
R_VERSION=${1:-"3.5.1"}
echo "options(repos = c(options(\"repos\"), \"$REPO\"))"               >> /usr/local/lib/R/R-${R_VERSION}/lib/R/etc/Rprofile.site
echo ".First <- function() {"                                          >> /usr/local/lib/R/R-${R_VERSION}/lib/R/etc/Rprofile.site
echo "  cat(\"Repos are set to:\n\")"                                  >> /usr/local/lib/R/R-${R_VERSION}/lib/R/etc/Rprofile.site
echo "  for (repo in getOption(\"repos\")) cat(\"  -\", repo, \"\n\")" >> /usr/local/lib/R/R-${R_VERSION}/lib/R/etc/Rprofile.site
echo "  cat(\"Library paths are set to:\n\")"                          >> /usr/local/lib/R/R-${R_VERSION}/lib/R/etc/Rprofile.site
echo "  for (lib in .libPaths()) cat(\"  -\", lib, \"\n\")"            >> /usr/local/lib/R/R-${R_VERSION}/lib/R/etc/Rprofile.site
echo "}"                                                               >> /usr/local/lib/R/R-${R_VERSION}/lib/R/etc/Rprofile.site
