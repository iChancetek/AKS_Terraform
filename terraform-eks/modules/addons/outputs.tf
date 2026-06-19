
output "coredns_arn" {
  description = "ARN of the CoreDNS EKS Addon"
  value       = aws_eks_addon.coredns.arn
}

output "kube_proxy_arn" {
  description = "ARN of the Kube Proxy EKS Addon"
  value       = aws_eks_addon.kube_proxy.arn
}

output "ebs_csi_arn" {
  description = "ARN of the EBS CSI EKS Addon"
  value       = aws_eks_addon.ebs_csi.arn
}

output "metrics_server_release_name" {
  description = "Helm release name for the Metrics Server"
  value       = helm_release.metrics_server.name
}
