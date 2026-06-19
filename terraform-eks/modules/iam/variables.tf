variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider for IRSA (optional, passed after EKS cluster creation)"
  type        = string
  default     = ""
}

variable "oidc_provider_url" {
  description = "The URL of the OIDC Provider for IRSA (optional, passed after EKS cluster creation)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
