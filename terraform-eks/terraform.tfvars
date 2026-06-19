# =============================================================================
# Terraform EKS Configuration Variables Template
# Copy this file to 'terraform.tfvars' and customize for your deployment.
# =============================================================================

# AWS Region to deploy the primary infrastructure
aws_region = "us-east-1"

# AWS Region to deploy the DR infrastructure
aws_region_dr = "us-west-2"

# EKS Cluster Name
cluster_name = "eks-prod"

# EKS Cluster Kubernetes Version
cluster_version = "1.30"

# Custom VPC CIDR block
vpc_cidr = "10.0.0.0/16"

# Availability Zones to distribute primary resources (3 AZs for HA)
availability_zones = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]

# Availability Zones to distribute DR resources
availability_zones_dr = [
  "us-west-2a",
  "us-west-2b",
  "us-west-2c"
]

# Public Subnets CIDR blocks (Primary)
public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

# Public Subnets CIDR blocks (DR)
public_subnets_dr = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

# Private Subnets CIDR blocks (Primary)
private_subnets = [
  "10.0.11.0/24",
  "10.0.12.0/24",
  "10.0.13.0/24"
]

# Private Subnets CIDR blocks (DR)
private_subnets_dr = [
  "10.0.11.0/24",
  "10.0.12.0/24",
  "10.0.13.0/24"
]

# Managed Node Group Name
node_group_name = "general-workers"

# EC2 Instance Type for Worker Nodes
node_instance_type = "t3.micro"

# Worker Node Scaling Configuration
desired_capacity = 2
min_capacity     = 2
max_capacity     = 5

# Kubernetes API Endpoint Access Controls
enable_public_access  = true
enable_private_access = true

# Global tags applied to all resources
tags = {
  Environment  = "production"
  Project      = "eks-infrastructure"
  ManagedBy    = "terraform"
  "Created by" = "Terraform"
  Owner        = "Platform-Team"
}
