terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "serdyukoff"
    key    = ".terraform/terraform.tfstate"
    region = "eu-central-1"
  }
}
