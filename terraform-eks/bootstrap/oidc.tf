# =============================================================================
# GitHub Actions OpenID Connect (OIDC) Integration
# =============================================================================

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

# Create the OIDC Identity Provider in AWS
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

# Create the IAM Role that GitHub Actions will assume
resource "aws_iam_role" "github_actions" {
  name = "GitHubActions-Terraform-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:iChancetek/AKS_Terraform:*"
          }
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

# Grant the role full access to provision the infrastructure
# NOTE: In a strictly locked-down production environment, this should be scoped 
# down to only the permissions Terraform actually needs (VPC, EKS, IAM, Route53, etc).
resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "github_actions_role_arn" {
  description = "The ARN of the IAM Role for GitHub Actions to assume"
  value       = aws_iam_role.github_actions.arn
}
