## Install specific R version in Ubuntu


### Install R in your preferred version:

```
sudo bash bionic/install-r.sh <version> <date-for-mran>
```

### Set additional default repositories

```
sudo bash set-repo.sh <your-local-repo>
```

### Install R package in all installed R versions

```
sudo bash install-pkg.sh tidyverse
```

### Install all R packages from repo, for all R versions

```
sudo bash install-repo.sh <your-local-repo>
```

## Example

To install R in version 3.4.4 and 3.5.1 on one system, you can run:

```
sudo bash bionic/install-r.sh 3.4.4 2018-04-23
sudo bash bionic/install-r.sh 3.5.1 2018-08-31
sudo bash set-repo.sh <additional drat repos>
sudo bash install-pkg.sh tidyverse
sudo bash install-repo.sh <addition drat repos>
```

Now you have a 'base' stack of R packages for all your users installed. The
command `R` is bound to the latest version you installed. A specific version can
be launched using:

```
R -e 'sessionInfo()'
R-3.5.1 -e 'sessionInfo()'
R-3.4.4 -e 'sessionInfo()'
```
