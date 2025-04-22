output "cluster_id" {
  description = "The ID of the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_endpoint" {
  description = "The API endpoint of the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_certificate_authority_data" {
  description = "The certificate data for the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}
