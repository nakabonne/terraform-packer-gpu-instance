# packer-nvidia-driver

## Prerequisite

Install [direnv](https://direnv.net/).

Copy `.envrc.example` to `.envrc` and populate environment variables.

```
cp .envrc.example .envrc
```

Then run:

```
direnv allow
```

## Create an AMI

```bash
# Install packer
make ./bin/packer

cd packer
packer init .
packer fmt .
packer validate .
packer build nvidia-driver.pkr.hcl
```

## Provision instance

```bash
# Install terraform
make ./bin/terraform

cd terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```
