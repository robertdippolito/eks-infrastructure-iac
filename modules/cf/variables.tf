variable "nlb_dns_name" {
  description = "The DNS name of the pre-provisioned Network Load Balancer."
  type        = string
}

variable "origin_http_port" {
  description = "The port for HTTP communication with the origin (NLB)."
  type        = number
  default     = 80
}

variable "origin_https_port" {
  description = "The port for HTTPS communication with the origin."
  type        = number
  default     = 443
}

variable "origin_protocol_policy" {
  description = "Policy for communicating with the origin. E.g., 'http-only' or 'match-viewer'"
  type        = string
  default     = "http-only"
}

variable "origin_ssl_protocols" {
  description = "List of SSL/TLS protocols allowed when connecting to your origin."
  type        = list(string)
  default     = ["TLSv1.2"]
}

variable "comment" {
  description = "A comment describing the distribution."
  type        = string
  default     = "CloudFront distribution forwarding to NLB"
}

variable "price_class" {
  description = "Price class for CloudFront distribution. Valid values: PriceClass_100, PriceClass_200, PriceClass_All."
  type        = string
  default     = "PriceClass_All"
}

variable "aliases" {
  description = "A list of alternate domain names (CNAMEs) for your distribution."
  type        = list(string)
  default     = []
}

variable "default_root_object" {
  description = "The default object to serve (optional)."
  type        = string
  default     = ""
}

variable "viewer_protocol_policy" {
  description = "Specifies the protocol that viewers can use to access the objects. For example: 'redirect-to-https'."
  type        = string
  default     = "redirect-to-https"
}

variable "allowed_methods" {
  description = "A list of HTTP methods that you want CloudFront to process and forward to your origin."
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cached_methods" {
  description = "A list of HTTP methods that you want CloudFront to cache."
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "forward_query_string" {
  description = "Whether to forward query strings to the origin."
  type        = bool
  default     = false
}

variable "cookie_forwarding" {
  description = "Specifies how CloudFront handles cookies (e.g., 'none', 'all', 'whitelist')."
  type        = string
  default     = "none"
}

variable "forward_headers" {
  description = "A list of HTTP headers to forward to the origin (e.g. [\"Host\"])."
  type        = list(string)
  default     = ["Host"]
}

variable "min_ttl" {
  description = "Minimum time-to-live (in seconds) for objects in the CloudFront cache."
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "Default time-to-live (in seconds) for objects in the CloudFront cache."
  type        = number
  default     = 3600
}

variable "max_ttl" {
  description = "Maximum time-to-live (in seconds) for objects in the CloudFront cache."
  type        = number
  default     = 86400
}

variable "geo_restriction_type" {
  description = "Type of geo restriction: none, whitelist, or blacklist."
  type        = string
  default     = "none"
}

variable "geo_locations" {
  description = "List of country codes for the geo restriction."
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate to use for HTTPS."
  type        = string
}

variable "ssl_support_method" {
  description = "Specifies which SSL/TLS support method to use (sni-only, vip)."
  type        = string
  default     = "sni-only"
}

variable "minimum_protocol_version" {
  description = "Minimum SSL protocol version that CloudFront will use when communicating with viewers."
  type        = string
  default     = "TLSv1.2_2019"
}

variable "tags" {
  description = "A map of tags to assign to the CloudFront distribution."
  type        = map(string)
  default     = {}
}
