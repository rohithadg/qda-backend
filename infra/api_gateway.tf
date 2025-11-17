resource "aws_api_gateway_rest_api" "app" {
  name        = "${var.app_name}-api"
  description = "API Gateway for ${var.app_name}"

  tags = {
    Name = "${var.app_name}-api"
  }
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.app.id
  parent_id   = aws_api_gateway_rest_api.app.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id      = aws_api_gateway_rest_api.app.id
  resource_id      = aws_api_gateway_resource.proxy.id
  http_method      = "ANY"
  authorization    = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.app.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.app.invoke_arn
}

resource "aws_api_gateway_method" "root" {
  rest_api_id      = aws_api_gateway_rest_api.app.id
  resource_id      = aws_api_gateway_rest_api.app.root_resource_id
  http_method      = "ANY"
  authorization    = "NONE"
}

resource "aws_api_gateway_integration" "root_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.app.id
  resource_id             = aws_api_gateway_rest_api.app.root_resource_id
  http_method             = aws_api_gateway_method.root.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.app.invoke_arn
}

resource "aws_api_gateway_deployment" "app" {
  rest_api_id = aws_api_gateway_rest_api.app.id

  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.root_lambda
  ]
}

resource "aws_api_gateway_stage" "app" {
  deployment_id = aws_api_gateway_deployment.app.id
  rest_api_id   = aws_api_gateway_rest_api.app.id
  stage_name    = var.environment

  tags = {
    Name = "${var.app_name}-${var.environment}"
  }
}
