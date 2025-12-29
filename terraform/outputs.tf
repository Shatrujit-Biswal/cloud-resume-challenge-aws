# output "lambda_role_arn" {
#   description = "IAM role ARN used by Lambda"
#   value       = aws_iam_role.lambda_role.arn
# }


output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.resume_cdn.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.resume_cdn.id
}

output "bucket_name" {
  value = aws_s3_bucket.resume_s3.bucket
}

# output "bucket_arn" {
#   value = aws_s3_bucket.resume_s3.arn
# }

output "api_invoke_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "dynamodb_table" {
  value = aws_dynamodb_table.visitor_count.name
}
