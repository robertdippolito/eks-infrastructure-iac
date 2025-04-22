output "repository_url" {
  description = "URL of ECR repo"
  value       = data.aws_ecr_repository.ecr_repo.repository_url
}