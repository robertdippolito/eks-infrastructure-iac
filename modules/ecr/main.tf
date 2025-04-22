data "aws_ecr_repository" "ecr_repo" {
  name = "${var.namespace}/${var.repo_name}-${var.environment}"
}