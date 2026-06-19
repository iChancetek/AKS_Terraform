output "s3_bucket_name" {
  description = "The name of the S3 bucket created for storing state"
  value       = aws_s3_bucket.state.id
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table created for locking state"
  value       = aws_dynamodb_table.lock.id
}

output "aws_region" {
  description = "The AWS region where resources were created"
  value       = var.aws_region
}
