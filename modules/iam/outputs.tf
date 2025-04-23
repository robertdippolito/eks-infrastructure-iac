output "worker_role_arn" {
  description = "Role ARN"
  value       = aws_iam_role.eks_worker_role.arn
}

output "cluster_role_arn" {
  description = "Role ARN of the cluster role"
  value = aws_iam_role.cluster_role.arn
}