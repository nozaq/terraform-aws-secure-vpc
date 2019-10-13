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
  availability_zones      = ["ap-northeast-1a"]
  nat_subnet_cidr_blocks  = [local.nat_cidr]
  flow_logs_iam_role_name = "FlowLogsPublisher"
  flow_logs_group_name    = "SimpleVPCFlowLogs"

  tags = {
    Environment = "SimpleVPC"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

#---------------------------------------------------------------------------------------------------
# Public Subnet
#---------------------------------------------------------------------------------------------------

resource "aws_subnet" "dmz" {
  vpc_id     = module.simple_vpc.vpc_id
  cidr_block = local.dmz_cidr
}

resource "aws_route_table_association" "dmz" {
  subnet_id      = aws_subnet.dmz.id
  route_table_id = module.simple_vpc.public_route_table_id
}

resource "aws_network_acl" "dmz" {
  vpc_id     = module.simple_vpc.vpc_id
  subnet_ids = [aws_subnet.dmz.id]

  # allow all traffic from instances inside the VPC.
  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.management_ip
    from_port  = 0
    to_port    = 0
  }

  # allow all returning traffic from the internet.
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # allow all traffic to the internet.
  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_security_group" "bastion" {
  name        = "BastionSG"
  description = "Allow all inbound traffic"
  vpc_id      = module.simple_vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.management_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.nano"
  subnet_id                   = aws_subnet.dmz.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
}

#---------------------------------------------------------------------------------------------------
# Private Subnet
#---------------------------------------------------------------------------------------------------

resource "aws_subnet" "private" {
  vpc_id     = module.simple_vpc.vpc_id
  cidr_block = local.private_cidr
}

resource "aws_network_acl" "priavte" {
  vpc_id     = module.simple_vpc.vpc_id
  subnet_ids = [aws_subnet.private.id]

  # allow all traffic from instances inside the VPC.
  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = local.dmz_cidr
    from_port  = 0
    to_port    = 0
  }

  # allow all returning traffic from the internet.
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # allow all traffic to the internet.
  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_security_group" "private" {
  name        = "PrivateSG"
  description = "Allow all inbound traffic"
  vpc_id      = module.simple_vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
    # force an interpolation expression to be interpreted as a list by wrapping it
    # in an extra set of list brackets. That form was supported for compatibilty in
    # v0.11, but is no longer supported in Terraform v0.12.
    #
    # If the expression in the following list itself returns a list, remove the
    # brackets to avoid interpretation as a list of lists. If the expression
    # returns a single list item then leave it as-is and remove this TODO comment.
    cidr_blocks = [local.dmz_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "private" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.nano"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.private.id]
  key_name                    = var.key_name
  associate_public_ip_address = false
}

