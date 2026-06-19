provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "dr"
  region = var.aws_region_dr
}

provider "tls" {}

provider "time" {}

# ==================== PRIMARY K8S & HELM PROVIDERS ====================

provider "kubernetes" {
  host                   = module.eks_primary.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_primary.cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks_primary.cluster_name, "--region", var.aws_region]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks_primary.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_primary.cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks_primary.cluster_name, "--region", var.aws_region]
    }
  }
}

# ==================== DR K8S & HELM PROVIDERS ====================

provider "kubernetes" {
  alias = "dr"
  host                   = module.eks_dr.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_dr.cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks_dr.cluster_name, "--region", var.aws_region_dr]
  }
}

provider "helm" {
  alias = "dr"
  kubernetes {
    host                   = module.eks_dr.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_dr.cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks_dr.cluster_name, "--region", var.aws_region_dr]
    }
  }
}
