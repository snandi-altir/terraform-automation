provider "aws" {
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::540112356404:role/Terraform"
  }
}

terraform {
  # required_version = ">= 1.3.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }

  backend "s3" {
    bucket         = "hyperian-terraform-backends"
    key            = "dev/core/state"
    region         = "us-west-2"
    dynamodb_table = "hyperian-dev-core"
  }
}