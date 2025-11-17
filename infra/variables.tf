variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-6"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "qda-backend"
}

variable "lambda_memory" {
  description = "Lambda memory in MB"
  type        = number
  default     = 512
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 30
}

variable "lambda_code_path" {
  description = "Path to Lambda ZIP file"
  type        = string
  default     = "../lambda.zip"
}
