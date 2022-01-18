# terraform-aws-secure-vpc

[![Github Actions](https://github.com/nozaq/terraform-aws-secure-vpc/workflows/Terraform/badge.svg)](https://github.com/nozaq/terraform-aws-secure-vpc/actions?workflow=Terraform)

[Terraform Module Registry](https://registry.terraform.io/modules/nozaq/secure-vpc/aws)

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

module "secure_vpc" {
  source = "nozaq/secure-vpc/aws"

  aws_account_id          = data.aws_caller_identity.current.account_id
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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| assign\_generated\_ipv6\_cidr\_block | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. | string | `"false"` | no |
| availability\_zones | The availability zones to support with this VPC. | list | `[]` | no |
| aws\_account\_id | The AWS Account ID number of the account. | string | n/a | yes |
| cidr\_block | The CIDR block for the VPC. | string | n/a | yes |
| enable\_dns\_hostnames | A boolean flag to enable/disable DNS hostnames in the VPC. | string | `"false"` | no |
| enable\_dns\_support | A boolean flag to enable/disable DNS support in the VPC. | string | `"true"` | no |
| flow\_logs\_group\_name | The name of the CloudWatch Logs group for VPC Flow Logs. | string | n/a | yes |
| flow\_logs\_iam\_role\_name | The name of the IAM role to publish VPC Flow Logs. | string | n/a | yes |
| flow\_logs\_key\_deletion\_window\_in\_days | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days. | string | `"30"` | no |
| flow\_logs\_retention\_in\_days | Specifies the number of days you want to retain VPC Flow Logs events. | string | `"0"` | no |
| flow\_logs\_traffic\_type | The type of traffic to capture. Valid values: ACCEPT,REJECT, ALL | string | `"ALL"` | no |
| instance\_tenancy | A tenancy option for instances launched into the VPC | string | `"default"` | no |
| nat\_subnet\_cidr\_blocks | The CIDR blocks for the NAT subnets. | list | `[]` | no |
| tags | Tags to be attached to all resources created with this module. | map | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| default\_network\_acl\_id | The ID of the default network ACL |
| default\_route\_table\_id | The ID of the default route table |
| default\_security\_group\_id | The ID of the security group created by default on VPC creation |
| flow\_logs\_group\_arn | The ARN of the CloudWatch log group to which VPC Flow Logs will publish to. |
| internet\_gateway\_id | The ID of the internet gateawy |
| nat\_gateway\_ids | The ID of the NAT Gateawy |
| nat\_gateway\_private\_ips | The private IP address of the NAT Gateway |
| nat\_gateway\_public\_ips | The public IP address of the NAT Gateway |
| private\_route\_table\_id | The ID of the route table for private subnets |
| public\_route\_table\_id | The ID of the route table for public subnets |
| vpc\_cidr\_block | The CIDR block of the VPC |
| vpc\_enable\_dns\_hostnames | Whether or not the VPC has DNS hostname support |
| vpc\_enable\_dns\_support | Whether or not the VPC has DNS support |
| vpc\_id | The ID of the VPC |
| vpc\_instance\_tenancy | Tenancy of instances spin up within VPC |
| vpc\_main\_route\_table\_id | The ID of the main route table associated with this VPC |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

[CIS Amazon Web Services Foundations]: https://d0.awsstatic.com/whitepapers/compliance/AWS_CIS_Foundations_Benchmark.pdf
[CIS Amazon Web Services Three-tier Web Architecture Benchmark]: https://d1.awsstatic.com/whitepapers/compliance/CIS_Amazon_Web_Services_Three-tier_Web_Architecture_Benchmark.pdf