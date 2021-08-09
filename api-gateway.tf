# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "api"
}

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  }

resource "aws_api_gateway_stage" "api" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "api"
}

## ROTAS:
  ###### /health
resource "aws_api_gateway_resource" "health" {
  path_part   = "health"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.health.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.health.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.main.invoke_arn
}

  ###### /comment
resource "aws_api_gateway_resource" "comment" {
  path_part   = "comment"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

  ###### /comment/new
resource "aws_api_gateway_resource" "commentnew" {
  path_part   = "new"
  parent_id   = aws_api_gateway_resource.comment.id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

  ## /1
resource "aws_api_gateway_resource" "commentnew1" {
  path_part   = "1"
  parent_id   = aws_api_gateway_resource.commentnew.id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "commentnew1post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.commentnew1.id
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "integrationcommentnew1post" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.commentnew1.id
  http_method             = aws_api_gateway_method.commentnew1post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.main.invoke_arn
}

  ## /2
resource "aws_api_gateway_resource" "commentnew2" {
  path_part   = "2"
  parent_id   = aws_api_gateway_resource.commentnew.id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "commentnew2post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.commentnew2.id
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "integrationcommentnew2post" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.commentnew2.id
  http_method             = aws_api_gateway_method.commentnew2post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.main.invoke_arn
}

  ###### /comment/list
resource "aws_api_gateway_resource" "commentlist" {
  path_part   = "list"
  parent_id   = aws_api_gateway_resource.comment.id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

  ## /1
resource "aws_api_gateway_resource" "commentlist1" {
  path_part   = "1"
  parent_id   = aws_api_gateway_resource.commentlist.id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "commentlist1get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.commentlist1.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "integrationcommentlist1" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.commentlist1.id
  http_method             = aws_api_gateway_method.commentlist1get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.main.invoke_arn
}
  ## /2
resource "aws_api_gateway_resource" "commentlist2" {
  path_part   = "2"
  parent_id   = aws_api_gateway_resource.commentlist.id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "commentlist2get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.commentlist2.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "integrationcommentlist2" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.commentlist2.id
  http_method             = aws_api_gateway_method.commentlist2get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.main.invoke_arn
}

# Autorização para lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*"
}