resource "aws_eks_node_group" "eks_managed_nodes" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  instance_types = var.instance_types
  disk_size      = var.disk_size
  ami_type       = var.ami_type

  remote_access {
    ec2_ssh_key            = var.ec2_ssh_key
    source_security_group_ids = var.source_security_groups
  }

  update_config {
    max_unavailable = var.max_unavailable
  }

  tags = merge(
    {
      Name = var.node_group_name
    },
    var.extra_tags
  )
}
