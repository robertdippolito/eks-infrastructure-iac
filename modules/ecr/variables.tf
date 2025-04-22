variable "repo_name" {
  description = "The name of the ECR repo."
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  default     = "development"
}

variable "namespace" {
  description = "Namespace that the resource will be deployed to in Kubernetes"
  type        = string
}