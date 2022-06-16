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

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "server_ec2_instance"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "keyyy"
  monitoring             = true

  tags = {
    Name        = "Ubuntu Server on ec2 module"
    Owner       = "serdyukov"
    Project     = "Terraform lessons"
    Ddscription = "EC2 modiles"
  }

}

