resource "aws_s3_bucket" "resume_s3" {
  bucket = var.frontend_bucket_name
}

resource "aws_s3_bucket_versioning" "resume_s3" {
  bucket = aws_s3_bucket.resume_s3.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "resume_s3" {
  bucket = aws_s3_bucket.resume_s3.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "resume_s3" {
  bucket = aws_s3_bucket.resume_s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_policy" "resume_s3" {
  bucket = aws_s3_bucket.resume_s3.id

  # depends_on = [
  #   aws_cloudfront_distribution.resume_cdn
  # ]

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.resume_s3.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.resume_cdn.arn
          }
        }
      }
    ]
  })
}
