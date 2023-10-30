# packer-nvidia-driver

## Prerequisite

Install [direnv](https://direnv.net/).

Copy `.envrc.example` to `.envrc` and populate environment variables.
Then run:

```
direnv allow
```

## Packer Build

```bash
# Install packer
make ./bin/packer

cd packer
packer init .
packer fmt .
packer validate .
packer build nvidia-driver.pkr.hcl
```
