args <- commandArgs(trailing = TRUE)

mran <- args[1]
lib <- args[2]

install.packages("httr", lib = lib, repos = mran)
