terraform {
  backend "s3" {
    bucket = "comentarios-api-infra"
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"
  }
}