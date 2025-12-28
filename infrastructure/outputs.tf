output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.resume_cdn.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.resume_cdn.id
}

output "bucket_name" {
  value = aws_s3_bucket.resume_s3.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.resume_s3.arn
}