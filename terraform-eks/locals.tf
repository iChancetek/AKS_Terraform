locals {
  # Root-level configuration for unified tagging strategy
  tags = merge(
    var.tags,
    {
      TerraformManaged = "true"
      LastUpdated      = "2026-06-18" # Current date
    }
  )
}
