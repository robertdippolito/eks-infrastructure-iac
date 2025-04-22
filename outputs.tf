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