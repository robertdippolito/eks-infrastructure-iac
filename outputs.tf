output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

# output "eks_managed_node_group_id" {
#   value = module.eks_managed_nodes.node_group_id
# }

output "api_dns_name" {
  value = module.route53_api_record.record_fqdn
}

output "eks_oidc_provider_arn" {
  description = "EKS IAM OIDC provider ARN."
  value       = module.external_secrets_irsa.oidc_provider_arn
}

output "external_secrets_role_arn" {
  description = "IAM role ARN for external-secrets IRSA."
  value       = module.external_secrets_irsa.external_secrets_role_arn
}

output "external_secrets_policy_arn" {
  description = "IAM policy ARN for external-secrets."
  value       = module.external_secrets_irsa.external_secrets_policy_arn
}
