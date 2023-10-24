packer {
  required_version = ">= 1.8.0"
  required_plugins {
    amazon = {
      version = ">= 1.0.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "assume_role_arn" {
  type        = string
  default     = ""
  description = "AWS accounts ARN which we run Packer build"
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
  ami_name               = "learn-packer-linux-aws"
  instance_type          = "g4ad.xlarge"
  region                 = "ap-northeast-1"
  source_ami             = data.amazon-ami.ubuntu.id
  ssh_username           = "ubuntu"
  ssh_read_write_timeout = "5m" # To reconnect after packer hangs on a connection after a reboot.

  assume_role {
    role_arn     = var.assume_role_arn
    session_name = "nvidia-driver-builder"
  }

  temporary_iam_instance_profile_policy_document {
    Statement {
      Action   = ["s3:ListBucket"]
      Effect   = "Allow"
      Resource = ["arn:aws:s3:::arene-tools-team"]
    }
    Statement {
      Action   = ["s3:GetObject"]
      Effect   = "Allow"
      Resource = ["arn:aws:s3:::arene-tools-team/*"]
    }
    Version = "2012-10-17"
  }
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
    script       = "./scripts/install-driver.sh"
  }
}
