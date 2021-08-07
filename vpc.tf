resource "aws_vpc" "main" {
  cidr_block = "100.100.0.0/16"
}

resource "aws_subnet" "az-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "100.100.1.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "az-b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "100.100.2.0/24"
  availability_zone = "us-east-2b"
}