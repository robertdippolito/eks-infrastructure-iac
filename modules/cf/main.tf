resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = var.nlb_dns_name
    origin_id   = "nlb-origin"

    custom_origin_config {
      # Since an NLB provides a fixed endpoint we’re using HTTP.
      http_port              = var.origin_http_port
      https_port             = var.origin_https_port
      origin_protocol_policy = var.origin_protocol_policy  # e.g., "http-only", "match-viewer"
      origin_ssl_protocols   = var.origin_ssl_protocols
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.comment
  price_class         = var.price_class

  aliases = var.aliases

  default_root_object = var.default_root_object

  default_cache_behavior {
    target_origin_id       = "nlb-origin"
    viewer_protocol_policy = var.viewer_protocol_policy   # e.g., "redirect-to-https"
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods

    forwarded_values {
      query_string = var.forward_query_string
      headers = var.forward_headers

      cookies {
        forward = var.cookie_forwarding  # "none", "all", or "whitelist"
      }
    }


    min_ttl     = var.min_ttl
    default_ttl = var.default_ttl
    max_ttl     = var.max_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type  # "none", "blacklist", or "whitelist"
      locations        = var.geo_locations         # List of country codes (if applicable)
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.ssl_support_method       # e.g., "sni-only"
    minimum_protocol_version       = var.minimum_protocol_version # e.g., "TLSv1.2_2019"
    # Optionally, if you use a CloudFront certificate, you can provide:
    # cloudfront_default_certificate = false
  }

  tags = var.tags
}
