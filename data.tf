data "aws_security_group" "main" {
    vpc_id      = aws_vpc.main.id
    name        = "vpc_security_group"
}

data "aws_route_table" "main" {
    vpc_id      = aws_vpc.main.id
}