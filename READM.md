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

