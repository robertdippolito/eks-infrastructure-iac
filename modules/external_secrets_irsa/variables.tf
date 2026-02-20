variable "cluster_name" {
  description = "The EKS cluster name."
  type        = string
}

variable "oidc_issuer_url" {
  description = "The EKS OIDC issuer URL."
  type        = string
}

variable "oidc_audience" {
  description = "OIDC audience used for web identity role assumption."
  type        = string
  default     = "sts.amazonaws.com"
}

variable "external_secrets_namespace" {
  description = "Kubernetes namespace where external-secrets service account runs."
  type        = string
  default     = "external-secrets"
}

variable "external_secrets_service_account_name" {
  description = "Kubernetes service account name used by external-secrets."
  type        = string
  default     = "external-secrets"
}

variable "external_secrets_role_name" {
  description = "Optional IAM role name override for external-secrets IRSA role."
  type        = string
  default     = null
}

variable "external_secrets_policy_arns" {
  description = "Additional IAM policy ARNs to attach to the external-secrets role."
  type        = list(string)
  default     = []
}

variable "create_external_secrets_policy" {
  description = "Create the external-secrets policy in this module."
  type        = bool
  default     = true
}

variable "external_secrets_policy_name" {
  description = "Name of the external-secrets IAM policy created by this module."
  type        = string
  default     = "external-secrets-policy"
}

variable "external_secrets_policy_description" {
  description = "Description for the external-secrets IAM policy."
  type        = string
  default     = "Allows external-secrets to read from AWS Secrets Manager and SSM Parameter Store."
}

variable "external_secrets_policy_resources" {
  description = "Resource ARNs allowed by the external-secrets IAM policy."
  type        = list(string)
  default     = ["*"]
}

variable "tags" {
  description = "Tags to apply to IAM resources."
  type        = map(string)
  default     = {}
}
