resource "aws_vpc" "main" {
  cidr_block = "100.100.0.0/16"
}

resource "aws_subnet" "az-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "100.100.10.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "az-b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "100.100.20.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_security_group" "main" {
  name        = "vpc_security_group"
  description = "Default SG"
  vpc_id      = aws_vpc.main.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}