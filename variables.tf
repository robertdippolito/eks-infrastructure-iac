variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  default     = "development"
}

variable "backend_bucket" {
  description = "S3 bucket for storing Terraform state"
  type        = string
}

variable "backend_bucket_key" {
  description = "Key prefix within the state bucket"
  type        = string
}

variable "dynamodb_table" {
  description = "DynamoDB table used for state locking"
  type        = string
  default     = "terraform-locks"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS managed node group"
  type        = string
}

variable "repo_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "ec2_ssh_key" {
  description = "SSH key pair name for EC2 instances"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "aliases" {
  description = "Domain aliases for the CloudFront distribution"
  type        = list(string)
}

variable "zone_name" {
  description = "Route53 hosted zone name"
  type        = string
}

variable "zone_comment" {
  description = "Optional comment for the hosted zone"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Fully qualified domain name for the API"
  type        = string
}
