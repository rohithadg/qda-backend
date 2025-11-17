output "api_endpoint" {
  description = "API Gateway endpoint URL"
  value       = "${aws_api_gateway_stage.app.invoke_url}"
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.app.function_name
}

output "lambda_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.app.arn
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}
