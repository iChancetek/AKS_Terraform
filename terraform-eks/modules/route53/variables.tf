variable "domain_name" {
  description = "The domain name for the Route 53 hosted zone"
  type        = string
}

variable "primary_alb_endpoint" {
  description = "The endpoint URL of the primary application load balancer"
  type        = string
}

variable "dr_alb_endpoint" {
  description = "The endpoint URL of the DR application load balancer"
  type        = string
}
