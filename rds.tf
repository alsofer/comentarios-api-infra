resource "aws_db_instance" "default" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  name                   = var.db_name
  username               = local.db_creds.username
  password               = local.db_creds.password
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_db_security_group.default.id]
}

resource "aws_db_subnet_group" "default" {
  name                   = "main"
  subnet_ids             = [aws_subnet.az-a.id, aws_subnet.az-b.id]
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id              = "mysqlsecret"
}

locals {
  db_creds               = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}