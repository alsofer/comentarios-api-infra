resource "aws_vpc" "main" {
  cidr_block = "100.100.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
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

resource "aws_security_group" "lambda-sg" {
  name        = "lambda-sg"
  description = "Lambda function SG"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "lambda-out" {
  type              = "egress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = aws_security_group.main.id
  security_group_id = aws_security_group.lambda-sg.id
}

resource "aws_security_group_rule" "db-all" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id = "sg-014ac24e2e3545e4e"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "route-table-internet" {
  route_table_id              = data.aws_route_table.main.id
  destination_cidr_block      = "0.0.0.0/0"
  gateway_id                  = "igw-09572d2a3006b75cb"
}