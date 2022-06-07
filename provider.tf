terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.16.0"
    }
  }
}

provider "aws" {
  alias   = "account1"
  profile = "account1"
  region  = "us-west-1"
}

provider "aws" {
  alias   = "account2"
  profile = "account2"
  region  = "us-east-1"
}

