module "label" {
  source      = "cloudposse/label/null"
  version     = "0.25.0"
  namespace   = var.namespace
  environment = var.environment
  attributes  = var.attributes
  enabled     = var.enabled
  tags        = var.tags
  stage       = var.stage
  name        = var.name
}

locals {
  cidr            = "10.${var.cidr_b_block}.0.0/16"
  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  subnets         = cidrsubnets(local.cidr, 8, 8, 8, 8, )
  private_subnets = slice(local.subnets, 0, 2)
  public_subnets  = slice(local.subnets, 2, 4)

  tags = merge(module.label.tags, var.tags)
}

resource "aws_eip" "nat" {
  count = length(local.azs)

  vpc  = true
  tags = local.tags
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = var.vpc_name
  cidr = local.cidr
  azs  = local.azs

  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  enable_dns_support   = true
  enable_dns_hostnames = true
  default_route_table_name = "${var.vpc_name}-rtb"
  enable_vpn_gateway = false
  manage_default_route_table = false
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false  

  # Skip creation of EIPs for the NAT Gateways, use the ones created in this
  # module. This lets us keep the same IPs even after the VPC is destroyed and
  # re-created
  reuse_nat_ips       = true
  external_nat_ip_ids = aws_eip.nat.*.id

  tags = local.tags
}

resource "aws_vpc_peering_connection" "eks2rds" {
  # peer_owner_id = var.peer_owner_id
  peer_vpc_id   = module.vpc.vpc_id 
  vpc_id        = var.requester_vpc

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = false
  }
  auto_accept = true
}
# Data source to fetch the VPC's CIDR block using VPC ID
data "aws_vpc" "requester_vpc" {
  id =  var.requester_vpc
}

resource "aws_route" "eks2rds" {
  # ID of EKS Cluster VPC public route table.
  route_table_id = element(module.vpc.public_route_table_ids, 0)
  destination_cidr_block = data.aws_vpc.requester_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.eks2rds.id
}
resource "aws_route" "rds2eks" {
  # ID of Requester VPC main route table.
  route_table_id = data.aws_vpc.requester_vpc.main_route_table_id
  destination_cidr_block = module.vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.eks2rds.id
}

