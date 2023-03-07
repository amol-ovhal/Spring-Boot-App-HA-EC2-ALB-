resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      "Name" = format("%s", "${var.vpc_name}")
    },
    var.tags,
  )
}

resource "aws_flow_log" "vpc_flow_logs" {
  count                = var.enable_vpc_logs == true ? 1 : 0
  log_destination      = var.logs_bucket_arn
  log_destination_type = var.log_destination_type
  traffic_type         = var.traffic_type
  vpc_id               = aws_vpc.main.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      "Name" = format("%s-igw", var.env_name)
    },
    var.tags,
  )
}

module "publicRouteTable" {
  source     = "../tf-modules/publicRouteTable/"
  cidr       = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
  name       = format("%s-pub", var.env_name)
  vpc_id     = aws_vpc.main.id
  tags       = var.tags
}

module "PublicSubnets" {
  source             = "../tf-modules/PublicSubnets/"
  availability_zones = var.avaialability_zones
  subnet_name        = var.public_subnet_name
  route_table_id     = module.publicRouteTable.id
  subnets_cidr       = var.public_subnets_cidr
  vpc_id             = aws_vpc.main.id
  tags               = var.tags
}

module "nat-gateway" {
  source             = "../tf-modules/nat-gateway/"
  subnets_for_nat_gw = module.PublicSubnets.ids
  nat_name           = var.nat_name
  tags               = var.tags
}

module "privateRouteTable" {
  source     = "../tf-modules/privateRouteTable/"
  cidr       = "0.0.0.0/0"
  gateway_id = module.nat-gateway.ngw_id
  name       = format("%s-pvt", var.env_name)
  vpc_id     = aws_vpc.main.id
  tags       = var.tags
}

module "PrivateSubnets" {
  source             = "../tf-modules/PrivateSubnets/"
  availability_zones = var.avaialability_zones
  subnet_name        = var.private_subnet_name
  route_table_id     = module.privateRouteTable.id
  subnets_cidr       = var.private_subnets_cidr
  vpc_id             = aws_vpc.main.id
  tags               = var.tags
}

module "public_web_security_group" {
  source              = "../tf-modules/public_web_security_group/"
  enable_whitelist_ip = true
  name_sg             = var.public_web_sg_name
  vpc_id              = aws_vpc.main.id
  ingress_rule = {
    rules = {
      rule_list = [
        {
          description  = "Rule for port 80"
          from_port    = 80
          to_port      = 80
          protocol     = "tcp"
          cidr         = ["0.0.0.0/0"]
          source_SG_ID = []
        },
        {
          description  = "Rule for port 443"
          from_port    = 443
          to_port      = 443
          protocol     = "tcp"
          cidr         = ["0.0.0.0/0"]
          source_SG_ID = []
        }
      ]
    }
  }
}

module "pub_alb" {
  source                     = "../tf-modules/pub_alb/"
  alb_name                   = format("%s-pub-alb", var.env_name)
  internal                   = false
  logs_bucket                = var.logs_bucket
  security_groups_id         = [module.public_web_security_group.sg_id]
  subnets_id                 = module.PublicSubnets.ids
  tags                       = var.tags
  enable_logging             = var.enable_alb_logging
  enable_deletion_protection = var.enable_deletion_protection
}

