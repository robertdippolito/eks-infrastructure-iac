variable "cluster_name" {
  description = "The name of the existing EKS cluster."
  type        = string
}

variable "node_group_name" {
  description = "The name for the managed node group."
  type        = string
  default     = "eks-managed-nodes"
}

variable "node_role_arn" {
  description = "The ARN of the IAM role for the managed node group."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the node group."
  type        = list(string)
}

variable "desired_size" {
  description = "The desired number of nodes in the node group."
  type        = number
  default     = 2
}

variable "min_size" {
  description = "The minimum number of nodes in the node group."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum number of nodes in the node group."
  type        = number
  default     = 3
}

variable "instance_types" {
  description = "A list of EC2 instance types for the worker nodes."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "disk_size" {
  description = "The disk size (in GiB) for each worker node."
  type        = number
  default     = 20
}

variable "ami_type" {
  description = "The AMI type for the worker nodes. Options include AL2_x86_64, AL2_x86_64_GPU, or BOTTLEROCKET_x86_64."
  type        = string
  default     = "AL2_x86_64"
}

variable "ec2_ssh_key" {
  description = "The EC2 SSH key name to allow SSH access to the worker nodes."
  type        = string
  default     = ""
}

variable "source_security_groups" {
  description = "List of security group IDs to allow SSH access."
  type        = list(string)
  default     = []
}

variable "max_unavailable" {
  description = "The number of nodes that can be unavailable during an update."
  type        = number
  default     = 1
}

variable "extra_tags" {
  description = "Additional tags to attach to the managed node group."
  type        = map(string)
  default     = {}
}
