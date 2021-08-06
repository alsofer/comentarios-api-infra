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
  filename            = "api"


  runtime = "python3.8"

  environment {
    variables = {
      Team = "alsofer"
    }
  }
}