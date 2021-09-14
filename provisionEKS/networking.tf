module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main"
  cidr = "10.0.0.0/16"

  azs = var.availability_zones
  private_subnets = [
    "10.0.1.0/24",
  "10.0.2.0/24"]
  public_subnets = [
    "10.0.101.0/24",
  "10.0.102.0/24"]

  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/my-task-cluster" = "shared"
    "kubernetes.io/role/elb"                = "1"
  }

  tags = {
    Terraform = "true"
  }
}
