#---------------------------------------------------------------------------------------------------
# VPC
#---------------------------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.this.default_security_group_id
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = aws_vpc.this.default_network_acl_id
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = aws_vpc.this.default_route_table_id
}

output "vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = aws_vpc.this.instance_tenancy
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = aws_vpc.this.enable_dns_support
}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = aws_vpc.this.enable_dns_hostnames
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = aws_vpc.this.main_route_table_id
}

#---------------------------------------------------------------------------------------------------
# Route Tables
#---------------------------------------------------------------------------------------------------

output "public_route_table_id" {
  description = "The ID of the route table for public subnets"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "The ID of the route table for private subnets"
  value       = aws_route_table.private.id
}

#---------------------------------------------------------------------------------------------------
# Gateways
#---------------------------------------------------------------------------------------------------

output "internet_gateway_id" {
  description = "The ID of the internet gateawy"
  value       = aws_internet_gateway.gw.id
}

output "nat_gateway_ids" {
  description = "The ID of the NAT Gateawy"
  value       = aws_nat_gateway.gw.*.id
}

output "nat_gateway_public_ips" {
  description = "The public IP address of the NAT Gateway"
  value       = aws_nat_gateway.gw.*.public_ip
}

output "nat_gateway_private_ips" {
  description = "The private IP address of the NAT Gateway"
  value       = aws_nat_gateway.gw.*.private_ip
}

#---------------------------------------------------------------------------------------------------
# VPC Flow Logs
#---------------------------------------------------------------------------------------------------

output "flow_logs_group_arn" {
  description = "The ARN of the CloudWatch log group to which VPC Flow Logs will publish to."
  value       = aws_cloudwatch_log_group.flow_logs.arn
}

