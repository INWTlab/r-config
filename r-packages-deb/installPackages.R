args <- commandArgs(trailing = TRUE)

mran <- args[1]
lib <- args[2]

packages <- readLines("packages.txt")

install.packages(packages, lib = lib, repos = mran)
