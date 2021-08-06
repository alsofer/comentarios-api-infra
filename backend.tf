terraform {
  backend "s3" {
    bucket = "comentarios-api-infra"
    key    = "terraform"
    region = "us-east-2"
  }
}