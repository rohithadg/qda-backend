resource "aws_lambda_function" "app" {
  filename      = var.lambda_code_path
  function_name = var.app_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "dist/handler.handler"
  runtime       = "nodejs20.x"
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory

  source_code_hash = filebase64sha256(var.lambda_code_path)

  environment {
    variables = {
      NODE_ENV = var.environment
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_logs,
    aws_iam_role_policy_attachment.lambda_basic_execution
  ]

  tags = {
    Name = var.app_name
  }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.app.execution_arn}/*/*"
}
