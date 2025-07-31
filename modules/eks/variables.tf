variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_role_arn" {
  description = "The ARN of the IAM role that provides permissions for the EKS cluster to make calls to AWS services."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the EKS cluster."
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Whether the EKS cluster API endpoint is publicly accessible."
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Whether the EKS cluster API endpoint is accessible from within the VPC."
  type        = bool
  default     = false
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.21"
}

variable "tags" {
  description = "A map of tags to assign to the cluster."
  type        = map(string)
  default     = {}
}
