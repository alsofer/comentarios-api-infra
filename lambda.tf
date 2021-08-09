resource "aws_lambda_function" "main" {
  function_name       = "comentarios-api"
  role                = aws_iam_role.iam_for_lambda.arn
  handler             = "main.handler"
  s3_bucket           = "s3-comentarios-api"
  s3_key              = "api.zip"
  runtime             = "python3.8"

  vpc_config {
    subnet_ids         = [aws_subnet.az-a.id, aws_subnet.az-b.id]
    security_group_ids = [aws_security_group.lambda-sg.id]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_vpc_access_execution" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


#Lambda para criar tabela no banco de dados

module "db_provisioner" {
  source  = "aleks-fofanov/rds-lambda-db-provisioner/aws"
  version = "~> 2.0"

  name      = "comentarios-api-db-provisioner"
  namespace = "prod"
  stage     = "prod"

  db_instance_id                       = "comentarios-api-production-rds01"
  db_instance_security_group_id        = "sg-014ac24e2e3545e4e"
  db_master_password_ssm_param         = "mysqlsecret"
  db_master_password_ssm_param_kms_key = "DefaultEncryptionKey"

  db_name = "comentarios-api"

  vpc_config = {
    vpc_id             = "vpc-0c776cafe58b4328b"
    subnet_ids         = ["subnet-08610eec2f5291688", "subnet-0a128096a921e27ba"]
    security_group_ids = ["sg-0b8d7fbd67590ac85"]
  }
}