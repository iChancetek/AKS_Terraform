output "cluster_role_arn" {
  description = "The ARN of the EKS cluster IAM role"
  value       = aws_iam_role.cluster.arn
}

output "cluster_role_name" {
  description = "The name of the EKS cluster IAM role"
  value       = aws_iam_role.cluster.name
}

output "node_role_arn" {
  description = "The ARN of the EKS worker node IAM role"
  value       = aws_iam_role.node.arn
}

output "node_role_name" {
  description = "The name of the EKS worker node IAM role"
  value       = aws_iam_role.node.name
}

output "ebs_csi_role_arn" {
  description = "The ARN of the EBS CSI Driver IAM role"
  value       = aws_iam_role.ebs_csi.arn
}

output "app_role_arn" {
  description = "The ARN of the sample application IAM role"
  value       = aws_iam_role.app.arn
}
