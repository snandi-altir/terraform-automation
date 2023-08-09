locals {
  vpc = {
    private_subnets  = ["10.1.0.0/22", "10.1.4.0/22"]
    database_subnets = ["10.1.180.0/22", "10.1.184.0/22"]
    public_subnets   = ["10.1.200.0/22", "10.1.204.0/22"]
    cidr             = "10.1.0.0/16"

    enable_nat_gateway   = true
    single_nat_gateway   = true
    enable_dns_hostnames = true
    enable_dns_support   = true

    public_subnet_tags = {
      "kubernetes.io/role/elb" = "1"
    }

    private_subnet_tags = {
      "kubernetes.io/role/internal-elb" = "1"
    }
  }
}