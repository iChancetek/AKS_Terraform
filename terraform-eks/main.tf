# ==================== PRIMARY REGION (us-east-1) ====================

module "vpc_primary" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  cluster_name       = var.cluster_name
  tags               = local.tags
}

module "iam_primary" {
  source            = "./modules/iam"
  cluster_name      = var.cluster_name
  oidc_provider_arn = module.eks_primary.oidc_provider_arn
  oidc_provider_url = module.eks_primary.oidc_provider_url
  tags              = local.tags
}

module "eks_primary" {
  source                = "./modules/eks"
  cluster_name          = var.cluster_name
  cluster_version       = var.cluster_version
  cluster_role_arn      = module.iam_primary.cluster_role_arn
  node_role_arn         = module.iam_primary.node_role_arn
  vpc_id                = module.vpc_primary.vpc_id
  private_subnet_ids    = module.vpc_primary.private_subnet_ids
  node_group_name       = var.node_group_name
  node_instance_type    = var.node_instance_type
  desired_capacity      = var.desired_capacity
  min_capacity          = var.min_capacity
  max_capacity          = var.max_capacity
  enable_public_access  = var.enable_public_access
  enable_private_access = var.enable_private_access
  tags                  = local.tags
}

module "addons_primary" {
  source           = "./modules/addons"
  cluster_name     = module.eks_primary.cluster_name
  ebs_csi_role_arn = module.iam_primary.ebs_csi_role_arn

  depends_on = [
    module.eks_primary,
    module.iam_primary
  ]
}

# ==================== DR REGION (us-west-2) ====================

module "vpc_dr" {
  source             = "./modules/vpc"
  providers          = { aws = aws.dr }
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets_dr
  private_subnets    = var.private_subnets_dr
  availability_zones = var.availability_zones_dr
  cluster_name       = "${var.cluster_name}-dr"
  tags               = local.tags
}

module "iam_dr" {
  source            = "./modules/iam"
  providers         = { aws = aws.dr }
  cluster_name      = "${var.cluster_name}-dr"
  oidc_provider_arn = module.eks_dr.oidc_provider_arn
  oidc_provider_url = module.eks_dr.oidc_provider_url
  tags              = local.tags
}

module "eks_dr" {
  source                = "./modules/eks"
  providers             = { aws = aws.dr }
  cluster_name          = "${var.cluster_name}-dr"
  cluster_version       = var.cluster_version
  cluster_role_arn      = module.iam_dr.cluster_role_arn
  node_role_arn         = module.iam_dr.node_role_arn
  vpc_id                = module.vpc_dr.vpc_id
  private_subnet_ids    = module.vpc_dr.private_subnet_ids
  node_group_name       = var.node_group_name
  node_instance_type    = var.node_instance_type
  desired_capacity      = var.desired_capacity
  min_capacity          = var.min_capacity
  max_capacity          = var.max_capacity
  enable_public_access  = var.enable_public_access
  enable_private_access = var.enable_private_access
  tags                  = local.tags
}

module "addons_dr" {
  source           = "./modules/addons"
  providers        = { aws = aws.dr, kubernetes = kubernetes.dr, helm = helm.dr }
  cluster_name     = module.eks_dr.cluster_name
  ebs_csi_role_arn = module.iam_dr.ebs_csi_role_arn

  depends_on = [
    module.eks_dr,
    module.iam_dr
  ]
}

# ==================== ROUTE 53 FAILOVER ====================
module "route53_dr" {
  source = "./modules/route53"
  
  domain_name = "example-dr-placeholder.com"
  
  # In a real environment, these would map to the ALBs deployed by AWS Load Balancer Controller
  primary_alb_endpoint = "dualstack.internal-primary-alb-placeholder.us-east-1.elb.amazonaws.com"
  dr_alb_endpoint      = "dualstack.internal-dr-alb-placeholder.us-west-2.elb.amazonaws.com"
}
