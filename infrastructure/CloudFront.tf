resource "aws_cloudfront_origin_access_control" "resume_oac" {
  name                              = "${var.project_name}-oac"
  description                       = "OAC for Cloud Resume Challenge frontend"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "resume_cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = "Cloud Resume Challenge Frontend"

  # ✅ Custom domain aliases
  aliases = [
    "shatrujitbiswal.com",
    "www.shatrujitbiswal.com"
  ]

  # ✅ REQUIRED: WAF (because pricing plan requires it)
  web_acl_id = "arn:aws:wafv2:us-east-1:927599149488:global/webacl/CreatedByCloudFront-d1b936be/c9eef4f6-b85e-4c44-b055-4b37e10625cc"

  origin {
    domain_name              = aws_s3_bucket.resume_s3.bucket_regional_domain_name
    origin_id                = "s3-resume-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.resume_oac.id

    connection_attempts = 3
    connection_timeout  = 10
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-resume-origin"
    viewer_protocol_policy = "redirect-to-https"

    compress = true

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # ✅ ACM certificate (must be in us-east-1)
  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:927599149488:certificate/bd27712a-52f4-4c7b-b107-0c807fe4da9d"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Project = var.project_name
  }

  # 🛡️ Safety net
  lifecycle {
    prevent_destroy = true
  }
}
