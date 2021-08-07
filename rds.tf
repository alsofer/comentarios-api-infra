module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "comentariosmysql"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.micro"
  allocated_storage = 5

  name     = "comentariosmysql"
  username = local.db_creds.username
  password = local.db_creds.password
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [data.aws_security_group.main.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  monitoring_interval = "30"
  monitoring_role_name = "MyRDSMonitoringRole"
  create_monitoring_role = true


  # DB subnet group
  subnet_ids = [aws_subnet.az-a.id, aws_subnet.az-b.id]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id              = "mysqlsecret"
}

locals {
  db_creds               = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}