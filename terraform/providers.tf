terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.42.0"
    }
  }
  backend "s3" {
    bucket = "terraform-lambdaclass"
    key = "worldcoin/terraform.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-east-1"
}
