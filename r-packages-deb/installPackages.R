## generate package list
## install.packages("miniCRAN")
## library(miniCRAN)
## inwtPkgs <- available.packages(repos = "https://inwt-vmeh2.inwt.de/r-repo")
## deps <- pkgDep(rownames(inwtPkgs), availPkgs = available.packages())
## toInstall <- setdiff(deps, rownames(inwtPkgs))
## writeLines(toInstall, "packages.txt"

args <- commandArgs(trailing = TRUE)

mran <- args[1]
lib <- args[2]

packages <- readLines("packages.txt")

install.packages(packages, lib = lib, repos = mran)
