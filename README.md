# packer-nvidia-driver

## Prerequisite

Copy `.envrc.example` to `.envrc` and populate environment variables.
Then run:

```
direnv allow
```

Install Packer

```
make ./bin/packer
```

## Build

Install plugin

```
packer init .
```

Format and validate

```
packer fmt .
packer validate .
```

Build

```
packer build nvidia-driver.pkr.hcl
```
