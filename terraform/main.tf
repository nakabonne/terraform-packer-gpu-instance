terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "instance" {
  ami           = "ami-077902db38c83c654" # Update this whenever new AMI is created by Packer
  instance_type = var.instance_type

  tags = {
    Name = "nvidia-driver"
  }
}
