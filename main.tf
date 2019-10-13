#---------------------------------------------------------------------------------------------------
# VPC
#---------------------------------------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  tags                             = var.tags
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id
  tags   = var.tags
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id
  tags                   = var.tags
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.this.default_route_table_id
  tags                   = var.tags
}

