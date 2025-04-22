#SECURITY GROUPS
resource "aws_security_group" "k8s_api_vpc_sg" {
  name        = "${var.cluster_name}-worker-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  # Allow nodes within the group to communicate with each other
  ingress {
    description      = "Allow node-to-node communication"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    self             = true
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-worker-sg"
  }
}