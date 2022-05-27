# Configure the AWS Provider
provider "aws" {
  region     = "eu-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_instance" "test_netology_aws" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  monitoring = true

  tags = {
    Name = "Ubuntu Server for Netology"
    Owner = "serdyukov"
    Project = "Terraform lessons"

  }
}

