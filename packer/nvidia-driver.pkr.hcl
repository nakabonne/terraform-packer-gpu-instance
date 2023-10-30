packer {
  required_version = ">= 1.8.0"
  required_plugins {
    amazon = {
      version = ">= 1.0.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

data "amazon-ami" "ubuntu" {
  filters = {
    virtualization-type = "hvm"
    architecture        = "x86_64"
    name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    root-device-type    = "ebs"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = "ap-northeast-1"
}

source "amazon-ebs" "ubuntu22-ami" {
  ami_name               = "ubuntu22-nvidia-driver"
  instance_type          = "g4dn.xlarge"
  region                 = "ap-northeast-1"
  source_ami             = data.amazon-ami.ubuntu.id
  ssh_username           = "ubuntu"
  ssh_read_write_timeout = "5m" # To reconnect after packer hangs on a connection after a reboot.
}

build {
  # Ref: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/install-nvidia-driver.html
  name    = "install-nvidia-driver"
  sources = ["source.amazon-ebs.ubuntu22-ami"]

  provisioner "shell" {
    script = "./scripts/upgrade-linux-aws.sh"
    # Because the script reboot at the end.
    expect_disconnect = true
  }

  provisioner "shell" {
    pause_before = "120s"
    script       = "./scripts/install-driver.sh"
    # Because the script reboot at the end.
    expect_disconnect = true
  }

  provisioner "shell" {
    pause_before = "120s"
    script       = "./scripts/install-nvidia-container-toolkit.sh"
  }
}
