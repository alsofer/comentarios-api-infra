resource "aws_lambda_function" "main" {
  function_name       = "comentarios-api"
  role                = aws_iam_role.iam_for_lambda.arn
  handler             = "main.handler"
  s3_bucket           = "s3-comentarios-api"
  s3_key              = "api.zip"
  runtime             = "python3.8"

  environment {
    variables = {
      DbConnectionString = local.db_string.string
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.az-a.id, aws_subnet.az-b.id]
    security_group_ids = [aws_security_group.lambda-sg.id]
  }
}

data "aws_secretsmanager_secret_version" "dbstring" {
  secret_id              = "mysqlstring"
}

locals {
  db_string               = jsondecode(
    data.aws_secretsmanager_secret_version.dbstring.secret_string
  )
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