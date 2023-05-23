terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }

  backend "s3" {
    bucket         = "tf-aws-intro-147826604809"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "tf_aws_intro_terraform_state_lock_147826604809"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Terraform = true
    }
  }
}
