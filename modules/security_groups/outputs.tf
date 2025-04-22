output "sg_id" {
  description = "Security group ID"
  value       = aws_security_group.k8s_api_vpc_sg.id
}