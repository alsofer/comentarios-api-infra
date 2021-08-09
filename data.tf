data "aws_security_group" "main" {
    vpc_id      = aws_vpc.main.id
    name        = "vpc_security_group"
}

data "aws_route_table" {
    id = "rtb-0d9e6caa49696c163"
}