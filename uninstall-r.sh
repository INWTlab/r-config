#!/bin/bash
# uninstall an r installation
R_VERSION=/usr/local/bin/R-${1:-"3.5.2"}
RSCRIPT_VERSION=/usr/local/bin/Rscript-${1:-"3.5.2"}
R_VERSION_NAME=`basename $R_VERSION | cat | sed -r 's/^R-//g'`
R_LIBRARY=~/R/x86_64-pc-linux-gnu-library/$R_VERSION_NAME
R_INSTALLATION=/usr/local/lib/R/$R_VERSION_NAME

echo "removing R from PATH: $R_VERSION"
rm -rf $R_VERSION

echo "removing Rscript from PATH: $RSCRIPT_VERSION"
rm -rf $RSCRIPT_VERSION

echo "removing library in $R_LIBRARY"
rm -rf $R_LIBRARY

echo "removing installation folder $R_LIBRARY"
rm -rf $R_INSTALLATION

echo ""
echo "Please make sure that R and Rscript point to a valid R version. Use:"
echo "  ln -s /path/to/your/R /usr/local/bin/R"
echo "  ln -s /path/to/your/Rscript /usr/local/bin/Rscript"
