## Install specific R version in Ubuntu


### Install R in your preferred version:

```
sudo bash bionic/install-r.sh <version> <date-for-mran>
```

### Set additional default repositories

```
export REPO=<your-local-repo> 
sudo bash set-repo.sh <version>
```

### Install R package

```
sudo bash install-pkg.sh <version> <pkg>
```

### Install all R packages from repo

```
export REPO=<your-local-repo> 
sudo bash install-repo.sh <version>
```

### Uninstall all R packages from repo

```
export REPO=<your-local-repo> 
sudo bash uninstall-repo.sh <version>
```

## Example

To install R in version 3.5.1 and 3.5.2 on one system, you can run:

```
sudo bash bionic/install-r.sh 3.5.1 2018-08-31
sudo bash bionic/install-r.sh 3.5.2 2019-03-10
# set repository
export REPO=<your-local-repo> 
sudo bash set-repo.sh 3.5.1
sudo bash set-repo.sh 3.5.2
# install packages
sudo bash install-pkg.sh 3.5.1 tidyverse
sudo bash install-pkg.sh 3.5.2 tidyverse
# install repositories
sudo bash install-repo.sh 3.5.1
sudo bash install-repo.sh 3.5.2
```

Now you have a 'base' stack of R packages for all your users installed. The
command `R` is bound to the latest version you installed. A specific version can
be launched using:

```
R -e 'sessionInfo()'
R-3.5.1 -e 'sessionInfo()'
R-3.5.2 -e 'sessionInfo()'
```

## Gotchas

`bionic/install-r.sh` assumes that the local installation of apt has the source
repositories for r-base activated. If this is not the case, e.g. in a fresh
installation of a server ubuntu, you may add the following lines to the
configuration:

```
sudo su -c "echo 'deb-src http://de.archive.ubuntu.com/ubuntu/ bionic universe
deb-src http://de.archive.ubuntu.com/ubuntu/ bionic-updates universe' > /etc/apt/sources.list.d/r-sources.list"
sudo apt update
```

and remove it with

```
sudo rm /etc/apt/sources.list.d/r-sources.list
sudo apt clean
sudo apt update
```
