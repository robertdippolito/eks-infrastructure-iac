output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.cloudfront.id
}

output "cloudfront_hosted_zone_id" {
  description = "The ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.cloudfront.hosted_zone_id
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name of the CloudFront distribution."
  value       = aws_cloudfront_distribution.cloudfront.domain_name
}
