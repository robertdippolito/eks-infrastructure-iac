variable "project_name" {
  description = "The name of the project."
  type        = string
  default     = "My Project"
}

variable "zone_name" {
  description = "The apex domain name for the hosted zone (e.g. robertdippolito.me)."
  type        = string
}

variable "zone_comment" {
  description = "Optional comment for the hosted zone."
  type        = string
  default     = "Hosted zone for domain"
}

variable "domain_name" {
  description = "The fully qualified domain name (FQDN) you want to create an alias record for (e.g. api.robertdippolito.me)."
  type        = string
}

variable "cloudfront_domain" {
  description = "The CloudFront distribution domain name (for example, d111111abcdef8.cloudfront.net)."
  type        = string
}

variable "cloudfront_hosted_zone_id" {
  description = "The CloudFront distribution id"
  type        = string
}

variable "acm_certificate_validation" {
  description = "ACM certificate for DNS validation."
  type = list(object({
    fqdn = string
  }))
}


variable "tags" {
  description = "A map of tags to assign to the hosted zone and record."
  type        = map(string)
  default     = {}
}
