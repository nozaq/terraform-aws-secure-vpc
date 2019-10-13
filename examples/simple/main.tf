#---------------------------------------------------------------------------------------------------
# Example Configuration w/ public & private subnets
#---------------------------------------------------------------------------------------------------

locals {
  vpc_cidr     = "10.0.0.0/16"
  nat_cidr     = "10.0.254.0/24"
  dmz_cidr     = "10.0.0.0/24"
  private_cidr = "10.0.1.0/24"
}

#---------------------------------------------------------------------------------------------------
# VPC 
#---------------------------------------------------------------------------------------------------
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

data "aws_caller_identity" "current" {
}

module "simple_vpc" {
  source = "../../"

  aws_account_id          = data.aws_caller_identity.current.account_id
  cidr_block              = local.vpc_cidr
  availability_zones      = ["us-east-1a"]
  nat_subnet_cidr_blocks  = [local.nat_cidr]
  flow_logs_iam_role_name = "FlowLogsPublisher"
  flow_logs_group_name    = "SimpleVPCFlowLogs"

  tags = {
    Environment = "SimpleVPC"
  }
}
