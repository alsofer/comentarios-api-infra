terraform {
  backend "s3" {
    bucket = "internet"
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"
  }
}