terraform {
  backend "s3" {
    bucket = "comentarios-api-terraform"
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.53.0"
    }
  }
}

provider "aws" {}