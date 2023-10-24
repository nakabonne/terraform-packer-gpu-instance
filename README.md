# packer-nvidia-driver

## Prerequisite

Copy `.envrc.example` to `.envrc` and populate environment variables.
Then run:

```
direnv allow
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
packer build --var-file=release.pkrvars.hcl nvidia-driver.pkr.hcl
```
