variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "ebs_csi_role_arn" {
  description = "The ARN of the IAM role for the EBS CSI Driver (IRSA)"
  type        = string
}
