terraform {
  backend "s3" {
    bucket = "comentarios-api"
    key    = "terraform"
    region = "us-east-2"
  }
}