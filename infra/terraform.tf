terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "rohithadg-org"  # Replace with your Terraform Cloud organization

    workspaces {
      name = "qda-backend"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "qda-backend"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
