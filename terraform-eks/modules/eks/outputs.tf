output "cluster_name" {
  description = "The EKS cluster name"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "The EKS cluster control plane API endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_arn" {
  description = "The EKS cluster ARN"
  value       = aws_eks_cluster.this.arn
}

output "cluster_ca_certificate" {
  description = "The base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider for EKS IRSA"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  description = "The URL of the OIDC Provider for EKS IRSA"
  value       = aws_iam_openid_connect_provider.eks.url
}

output "node_group_arn" {
  description = "The ARN of the worker node group"
  value       = aws_eks_node_group.this.arn
}

output "cluster_security_group_id" {
  description = "Security group ID of the control plane"
  value       = aws_security_group.cluster.id
}

output "node_security_group_id" {
  description = "Security group ID of the worker nodes"
  value       = aws_security_group.node_sg.id
}
