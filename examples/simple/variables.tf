variable "access_key" {}
variable "secret_key" {}

variable "region" {
  description = "The AWS region in which global resources are set up."
  default     = "us-east-1"
}

variable "management_ip" {
  description = "The IP address from which an administrator connects to instances via SSH."
}

variable "key_name" {
  description = "The key name to use for EC2 instances."
}
