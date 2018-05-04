# terraform-aws-secure-vpc

A terraform module to create a VPC with secure default configurations.
Most configurations are based on [CIS Amazon web Services Foundations] and [CIS Amazon Web Services Three-tier Web Architecture Benchmark].

The primary goal of this module is to create a VPC itself in a secure manner without any boilerplate code hence it does not create any subnets except ones for NAT Gateways.

## Features

- Disable insecure default configurations, e.g. denying all traffic in the default security group etc.
- Enable VPC Flow Logs to monitor all traffic type.
- Create NAT Gateways in each availability zones with the dedicated subnets and Network ACL rules.
- Create route tables for public/private subnets and set the private settings as default.

## Usage

```hcl
data "aws_caller_identity" "current" {}

module "simple_vpc" {
  source = "../../"

  aws_account_id          = "${data.aws_caller_identity.current.account_id}"
  cidr_block              = "10.0.0.0/8"
  availability_zones      = ["ap-northeast-1a", "ap-northeast-1c"]
  nat_subnet_cidr_blocks  = ["10.0.253.0/24", "10.0.254.0/24"]
  flow_logs_iam_role_name = "FlowLogsPublisher"
  flow_logs_group_name    = "SimpleVPCFlowLogs"

  tags = {
    Environment = "SimpleVPC"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| assign_generated_ipv6_cidr_block | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. | string | `false` | no |
| availability_zones | The availability zones to support with this VPC. | string | `<list>` | no |
| aws_account_id | The AWS Account ID number of the account. | string | - | yes |
| cidr_block | The CIDR block for the VPC. | string | - | yes |
| enable_dns_hostnames | A boolean flag to enable/disable DNS hostnames in the VPC. | string | `false` | no |
| enable_dns_support | A boolean flag to enable/disable DNS support in the VPC. | string | `true` | no |
| flow_logs_group_name | The name of the CloudWatch Logs group for VPC Flow Logs. | string | - | yes |
| flow_logs_iam_role_name | The name of the IAM role to publish VPC Flow Logs. | string | - | yes |
| flow_logs_key_deletion_window_in_days | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days. | string | `30` | no |
| flow_logs_retention_in_days | Specifies the number of days you want to retain VPC Flow Logs events. | string | `0` | no |
| flow_logs_traffic_type | The type of traffic to capture. Valid values: ACCEPT,REJECT, ALL | string | `ALL` | no |
| instance_tenancy | A tenancy option for instances launched into the VPC | string | `default` | no |
| nat_subnet_cidr_blocks | The CIDR blocks for the NAT subnets. | string | `<list>` | no |
| tags | Tags to be attached to all resources created with this module. | string | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| default_network_acl_id | The ID of the default network ACL |
| default_route_table_id | The ID of the default route table |
| default_security_group_id | The ID of the security group created by default on VPC creation |
| flow_logs_group_arn | The ARN of the CloudWatch log group to which VPC Flow Logs will publish to. |
| internet_gateway_id | The ID of the internet gateawy |
| nat_gateway_ids | The ID of the NAT Gateawy |
| nat_gateway_private_ips | The private IP address of the NAT Gateway |
| nat_gateway_public_ips | The public IP address of the NAT Gateway |
| private_route_table_id | The ID of the route table for private subnets |
| public_route_table_id | The ID of the route table for public subnets |
| vpc_cidr_block | The CIDR block of the VPC |
| vpc_enable_dns_hostnames | Whether or not the VPC has DNS hostname support |
| vpc_enable_dns_support | Whether or not the VPC has DNS support |
| vpc_id | The ID of the VPC |
| vpc_instance_tenancy | Tenancy of instances spin up within VPC |
| vpc_main_route_table_id | The ID of the main route table associated with this VPC |

[CIS Amazon Web Services Foundations]: https://d0.awsstatic.com/whitepapers/compliance/AWS_CIS_Foundations_Benchmark.pdf
[CIS Amazon Web Services Three-tier Web Architecture Benchmark]: https://d1.awsstatic.com/whitepapers/compliance/CIS_Amazon_Web_Services_Three-tier_Web_Architecture_Benchmark.pdf