terraform {
  backend "s3" {
    profile = "account1"
    bucket  = "tfstate-bucket-s3"
    key     = "terraform.tfstate"
    region  = "us-east-1"
  }
}