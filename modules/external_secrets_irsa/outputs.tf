output "oidc_provider_arn" {
  description = "OIDC provider ARN associated with the EKS cluster."
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "external_secrets_role_arn" {
  description = "IAM role ARN for external-secrets IRSA."
  value       = aws_iam_role.external_secrets.arn
}

output "external_secrets_role_name" {
  description = "IAM role name for external-secrets IRSA."
  value       = aws_iam_role.external_secrets.name
}

output "external_secrets_policy_arn" {
  description = "IAM policy ARN managed by this module for external-secrets."
  value       = try(aws_iam_policy.external_secrets[0].arn, null)
}
