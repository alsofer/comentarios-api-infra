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

resource "aws_lambda_function" "main" {
  function_name       = "comentarios-api"
  role                = aws_iam_role.iam_for_lambda.arn
  handler             = "main.handler"
  s3_bucket           = "comentarios-api"
  s3_key              = "api.zip"
  runtime             = "python3.8"

  vpc_config {
    subnet_ids         = [aws_subnet.az-a.id]
    security_group_ids = [aws_security_group.lambda.id]
  }
}