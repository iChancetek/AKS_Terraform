variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The EKS cluster version"
  type        = string
}

variable "cluster_role_arn" {
  description = "The ARN of the IAM role for the EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "The ARN of the IAM role for the EKS worker nodes"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where EKS is deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS control plane"
  type        = list(string)
}

variable "node_group_name" {
  description = "The name of the managed worker node group"
  type        = string
}

variable "node_instance_type" {
  description = "Instance type for worker nodes"
  type        = string
}

variable "desired_capacity" {
  description = "The desired number of worker nodes"
  type        = number
}

variable "min_capacity" {
  description = "The minimum number of worker nodes"
  type        = number
}

variable "max_capacity" {
  description = "The maximum number of worker nodes"
  type        = number
}

variable "enable_public_access" {
  description = "Whether to enable the public endpoint for EKS cluster"
  type        = bool
  default     = true
}

variable "enable_private_access" {
  description = "Whether to enable the private endpoint for EKS cluster"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
