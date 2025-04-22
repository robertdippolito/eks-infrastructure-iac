output "hosted_zone_id" {
  description = "The ID of the created Route 53 hosted zone."
  value       = data.aws_route53_zone.hosted_zone.zone_id
}

output "record_fqdn" {
  description = "The fully qualified domain name of the created Route 53 record."
  value       = aws_route53_record.route53_record.fqdn
}

output "cert_validation" {
  description = "The fully qualified domain name of the created Route 53 record."
  value       = aws_route53_record.cert_validation
}

output "acm_certificate_arn" {
  description = "ARN of ACM certificate"
  value       = aws_acm_certificate.acm_cert.arn
}

output "acm_certificate" {
  description = "ACM certificate"
  value       = aws_acm_certificate.acm_cert
}

output "acm_certificate_validation" {
  description = "The ACM certificate validation resource."
  value       = aws_acm_certificate_validation.acm_cert_validation
}