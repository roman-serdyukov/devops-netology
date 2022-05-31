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

locals {
  web_instance_type_map = {
    stage = "t1.micro"
    prod = "t2.micro"
  }
  web_instance_count_map = {
    stage = 1
    prod = 2
  }
}

resource "aws_instance" "ubuntu_netology_aws" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type_map[terraform.workspace]
  count         = local.web_instance_count_map[terraform.workspace]
  monitoring = true

  tags = {
    Name        = "Ubuntu Server Number ${count.index + 1}"
    Owner       = "serdyukov"
    Project     = "Terraform lessons"
    Ddscription = "AWS with count"
  }
  
  timeouts {
    create = "60m"
    delete = "2h"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"] 
  }
  filter {
    name = "owner-alias"
    values = ["amazon"] 
  }
}

locals {
  instances = {
    "t1.micro" = data.aws_ami.amazon_linux.id
    "t2.micro" = data.aws_ami.amazon_linux.id
  }
}
  
resource "aws_instance" "server_netology_aws" {
  for_each      = local.instances 
  
  ami           = each.value
  instance_type = each.key

  tags = {
    Name        = "Amazon Server on ${each.key}"
    Owner       = "serdyukov"
    Project     = "Terraform lessons"
    Ddscription = "AWS with for_each"
  }

  lifecycle {
  create_before_destroy = true
  prevent_destroy = true
  ignore_changes = [tags] 
  }
}