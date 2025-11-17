resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.app_name}"
  retention_in_days = 30

  tags = {
    Name = "${var.app_name}-logs"
  }
}
