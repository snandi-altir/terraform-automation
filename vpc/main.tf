module "vpc" {
  source               = "github.com/altirllc/infra-modules.git//terraform/modules/aws/vpc?ref=vpc-v5.0.0"
  owner                = var.owner
  environment          = var.environment
  private_subnets      = local.vpc.private_subnets
  public_subnets       = local.vpc.public_subnets
  database_subnets     = local.vpc.database_subnets
  cidr                 = local.vpc.cidr
  enable_nat_gateway   = local.vpc.enable_nat_gateway
  single_nat_gateway   = local.vpc.single_nat_gateway
  enable_dns_hostnames = local.vpc.enable_dns_hostnames
  enable_dns_support   = local.vpc.enable_dns_support
  public_subnet_tags   = local.vpc.public_subnet_tags
  private_subnet_tags  = local.vpc.private_subnet_tags
  tags                 = local.tags
}