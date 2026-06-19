variable "aws_region" {
  description = "The AWS region to deploy the state storage resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket to store the Terraform state. Must be globally unique."
  type        = string
  default     = "eks-prod-tf-state-chancellor-bucket"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to handle state locking"
  type        = string
  default     = "eks-prod-tf-state-lock"
}

variable "tags" {
  description = "Global tags to apply to the state resources"
  type        = map(string)
  default = {
    Environment = "production"
    ManagedBy   = "terraform-bootstrap"
    Project     = "eks-infrastructure"
  }
}
