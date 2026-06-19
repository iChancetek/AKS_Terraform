variable "aws_region" {
  description = "The AWS region where resources will be provisioned."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "The aws_region variable must be a valid AWS region name (e.g., us-east-1, eu-west-1)."
  }
}

variable "aws_region_dr" {
  description = "The DR AWS region where secondary resources will be provisioned."
  type        = string
  default     = "us-west-2"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region_dr))
    error_message = "The aws_region_dr variable must be a valid AWS region name (e.g., us-east-1, eu-west-1)."
  }
}

variable "cluster_name" {
  description = "The name of the Amazon EKS cluster."
  type        = string
  default     = "eks-prod"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.cluster_name))
    error_message = "The cluster_name variable must contain only alphanumeric characters, dashes, and underscores."
  }
}

variable "cluster_version" {
  description = "The Kubernetes version for the Amazon EKS cluster."
  type        = string
  default     = "1.30"

  validation {
    condition     = can(regex("^\\d+\\.\\d+$", var.cluster_version))
    error_message = "The cluster_version variable must be in major.minor format (e.g., 1.30)."
  }
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "A list of availability zones in the primary region"
  type        = list(string)
}

variable "availability_zones_dr" {
  description = "A list of availability zones in the DR region"
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of public subnets inside the primary VPC"
  type        = list(string)
}

variable "public_subnets_dr" {
  description = "A list of public subnets inside the DR VPC"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks for the primary region"
  type        = list(string)
}

variable "private_subnets_dr" {
  description = "List of private subnet CIDR blocks for the DR region"
  type        = list(string)
}



variable "node_group_name" {
  description = "The name of the EKS managed node group."
  type        = string
  default     = "general-workers"

  validation {
    condition     = length(var.node_group_name) > 0
    error_message = "The node_group_name must not be empty."
  }
}

variable "node_instance_type" {
  description = "The EC2 instance type for EKS worker nodes."
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "The desired number of worker nodes in the node group."
  type        = number
  default     = 2

  validation {
    condition     = var.desired_capacity >= 1
    error_message = "The desired capacity must be greater than or equal to 1."
  }
}

variable "min_capacity" {
  description = "The minimum number of worker nodes in the node group."
  type        = number
  default     = 2

  validation {
    condition     = var.min_capacity >= 1
    error_message = "The minimum capacity must be greater than or equal to 1."
  }
}

variable "max_capacity" {
  description = "The maximum number of worker nodes in the node group."
  type        = number
  default     = 5

  validation {
    condition     = var.max_capacity >= 1
    error_message = "The maximum capacity must be greater than or equal to 1."
  }
}

variable "enable_public_access" {
  description = "Whether to enable the public endpoint for the EKS control plane API."
  type        = bool
  default     = true
}

variable "enable_private_access" {
  description = "Whether to enable the private endpoint for the EKS control plane API."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Global tags to apply to all resources."
  type        = map(string)
  default = {
    Environment = "production"
    ManagedBy   = "terraform"
    Project     = "eks-infrastructure"
  }
}
