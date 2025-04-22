output "node_group_id" {
  description = "The ID of the managed node group."
  value       = aws_eks_node_group.eks_managed_nodes.id
}

output "node_group_name" {
  description = "The name of the managed node group."
  value       = aws_eks_node_group.eks_managed_nodes.node_group_name
}
