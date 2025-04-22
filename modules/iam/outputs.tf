output "role_arn" {
  description = "Role ARN"
  value       = aws_iam_role.eks_worker_role.arn
}