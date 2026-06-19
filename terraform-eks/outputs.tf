output "cluster_name" {
  description = "The EKS cluster name (Primary)"
  value       = module.eks_primary.cluster_name
}

output "cluster_endpoint" {
  description = "The EKS cluster control plane API endpoint (Primary)"
  value       = module.eks_primary.cluster_endpoint
}

output "cluster_arn" {
  description = "The EKS cluster ARN (Primary)"
  value       = module.eks_primary.cluster_arn
}

output "cluster_ca_certificate" {
  description = "The EKS cluster Certificate Authority (CA) data (Primary)"
  value       = module.eks_primary.cluster_ca_certificate
  sensitive   = true
}

output "oidc_provider_arn" {
  description = "The ARN of the EKS OIDC provider (Primary)"
  value       = module.eks_primary.oidc_provider_arn
}

output "node_group_arn" {
  description = "The ARN of the general-workers node group (Primary)"
  value       = module.eks_primary.node_group_arn
}

output "vpc_id" {
  description = "The custom VPC ID (Primary)"
  value       = module.vpc_primary.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs (Primary)"
  value       = module.vpc_primary.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs (Primary)"
  value       = module.vpc_primary.private_subnet_ids
}

output "cluster_security_group_id" {
  description = "Security Group ID of the EKS Cluster control plane (Primary)"
  value       = module.eks_primary.cluster_security_group_id
}

output "node_security_group_id" {
  description = "Security Group ID of the EKS worker nodes (Primary)"
  value       = module.eks_primary.node_security_group_id
}

output "region" {
  description = "The AWS region where primary resources are deployed"
  value       = var.aws_region
}
