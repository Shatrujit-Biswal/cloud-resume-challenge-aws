variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "lambda_role_arn" {
  description = "IAM role ARN for Lambda (from primary stack)"
  type        = string
}
