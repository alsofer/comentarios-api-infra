resource "aws_security_group" "lambda" {
  name        = "lambda-sg"
  description = "Managed by Terraform"
  vpc_id      = aws_vpc.main.id

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}