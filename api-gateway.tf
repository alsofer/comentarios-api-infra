resource "aws_api_gateway_rest_api" "main" {
  body = jsonencode({

openapi: 3.0.2
info:
  title: Comentários API
  description: Api de comentários online
  version: '0.1'
  x-logo:
    url: 'https://upload.wikimedia.org/wikipedia/pt/2/22/Logotipo_da_Rede_Globo.png'
servers:
  - url: https://phl66scaad.execute-api.us-east-2.amazonaws.com/api
    description: Production server
paths:
  /health:
    get:
      summary: Healthcheck
      operationId: healthcheck_api_health_get
      responses:
        '200':
          description: Successful Response
          content:
            application/json:
              schema: {}
  /comment/list/1:
    get:
      summary: Listar Comentários Sobre O Conteúdo 1
      operationId: listar_coment_rios_sobre_o_conte_do_1_comment_list_1_get
      responses:
        '200':
          description: Successful Response
          content:
            application/json:
              schema: {}
  /comment/list/2:
    get:
      summary: Listar Comentários Sobre O Conteúdo 2
      operationId: listar_coment_rios_sobre_o_conte_do_2_comment_list_2_get
      responses:
        '200':
          description: Successful Response
          content:
            application/json:
              schema: {}
  /comment/new/1:
    post:
      summary: Enviar Comentário Sobre O Conteúdo 1
      operationId: enviar_coment_rio_sobre_o_conte_do_1_comment_new_1_post
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateCommentsSchema'
        required: true
      responses:
        '201':
          description: Successful Response
          content:
            application/json:
              schema: {}
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
  /comment/new/2:
    post:
      summary: Enviar Comentário Sobre O Conteúdo 2
      operationId: enviar_coment_rio_sobre_o_conte_do_2_comment_new_2_post
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateCommentsSchema'
        required: true
      responses:
        '201':
          description: Successful Response
          content:
            application/json:
              schema: {}
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
components:
  schemas:
    CreateCommentsSchema:
      title: CreateCommentsSchema
      required:
        - email
        - comment
      type: object
      properties:
        email:
          title: Email
          type: string
        comment:
          title: Comment
          type: string
    HTTPValidationError:
      title: HTTPValidationError
      type: object
      properties:
        detail:
          title: Detail
          type: array
          items:
            $ref: '#/components/schemas/ValidationError'
    ValidationError:
      title: ValidationError
      required:
        - loc
        - msg
        - type
      type: object
      properties:
        loc:
          title: Location
          type: array
          items:
            type: string
        msg:
          title: Message
          type: string
        type:
          title: Error Type
          type: string
  })

  name = "api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.main.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = "api"
}

resource "aws_api_gateway_resource" "main" {
  path_part   = "health"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.main.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.main.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.main.invoke_arn
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}