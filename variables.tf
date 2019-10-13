#---------------------------------------------------------------------------------------------------
# General
#---------------------------------------------------------------------------------------------------

variable "aws_account_id" {
  description = "The AWS Account ID number of the account."
}

variable "tags" {
  description = "Tags to be attached to all resources created with this module."
  default     = {}
}

#---------------------------------------------------------------------------------------------------
# VPC
#---------------------------------------------------------------------------------------------------

variable "cidr_block" {
  description = "The CIDR block for the VPC."
}

variable "availability_zones" {
  description = "The availability zones to support with this VPC."
  default     = []
}

variable "nat_subnet_cidr_blocks" {
  description = "The CIDR blocks for the NAT subnets."
  default     = []
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  default     = true
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  default     = false
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block."
  default     = false
}

#---------------------------------------------------------------------------------------------------
# VPC Flow Logs
#---------------------------------------------------------------------------------------------------

variable "flow_logs_group_name" {
  description = "The name of the CloudWatch Logs group for VPC Flow Logs."
}

variable "flow_logs_iam_role_name" {
  description = "The name of the IAM role to publish VPC Flow Logs."
}

variable "flow_logs_retention_in_days" {
  description = "Specifies the number of days you want to retain VPC Flow Logs events."
  default     = "0"
}

variable "flow_logs_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT,REJECT, ALL"
  default     = "ALL"
}

variable "flow_logs_key_deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days."
  default     = "30"
}

