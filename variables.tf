variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  default     = "development"
}