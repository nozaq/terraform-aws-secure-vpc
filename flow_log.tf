data "aws_region" "current" {}

#---------------------------------------------------------------------------------------------------
# VPC Flow Logs
#---------------------------------------------------------------------------------------------------

resource "aws_kms_key" "flow_logs" {
  description             = "A KMS Key for encrypting VPC Flow Logs."
  enable_key_rotation     = true
  deletion_window_in_days = var.flow_logs_key_deletion_window_in_days

  policy = <<POLICY
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Sid" : "Enable IAM User Permissions",
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "arn:aws:iam::${var.aws_account_id}:root"
      },
      "Action" : "kms:*",
      "Resource" : "*"
    },
    {
      "Effect": "Allow",
      "Principal": { "Service": "logs.${data.aws_region.current.name}.amazonaws.com" },
      "Action": [ 
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ],
      "Resource": "*"
    }  
  ]
}
POLICY


  tags = var.tags
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = var.flow_logs_group_name
  kms_key_id        = aws_kms_key.flow_logs.id
  retention_in_days = var.flow_logs_retention_in_days
  tags              = var.tags
}

resource "aws_iam_role" "flow_logs_publisher" {
  name = var.flow_logs_iam_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "flow_logs_publisher_policy" {
  name = "${var.flow_logs_iam_role_name}-Policy"
  role = aws_iam_role.flow_logs_publisher.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "${aws_cloudwatch_log_group.flow_logs.arn}"
    }
  ]
}
EOF

}

resource "aws_flow_log" "all" {
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  iam_role_arn    = aws_iam_role.flow_logs_publisher.arn
  vpc_id          = aws_vpc.this.id
  traffic_type    = var.flow_logs_traffic_type
}

