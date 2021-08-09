module "rds" {
  source                          = "github.com/skyscrapers/terraform-rds//rds"
  vpc_id                          = aws_vpc.main.id
  subnets                         = [aws_subnet.az-a.id, aws_subnet.az-b.id]
  project                         = "comentarios-api"
  environment                     = "production"
  size                            = "db.t2.small"
  security_groups                 = ["sg-0b8d7fbd67590ac85"]
  enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]
  security_groups_count           = 1
  rds_password                    = local.db_creds.password
  rds_username                    = local.db_creds.username
  engine                          = "mysql"
  engine_version                  = "5.7.19"
  storage_encrypted               = false
  multi_az                        = "false"
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id              = "mysqlsecret"
}

locals {
  db_creds               = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}