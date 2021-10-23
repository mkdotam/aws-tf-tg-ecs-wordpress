
resource "aws_cloudwatch_log_group" "vpc_flow" {
  name              = "/vpc/flow/${var.project}-${var.env}"
  retention_in_days = 14

  tags = var.tags
}

resource "aws_flow_log" "vpc_flow" {
  iam_role_arn    = aws_iam_role.vpc_flow_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow.arn
  traffic_type    = "ALL"
  vpc_id          = module.vpc.vpc_id
}

resource "aws_iam_role" "vpc_flow_role" {
  name = "${var.project}-${var.env}-vpc-flow-role"

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

resource "aws_iam_role_policy" "vpc_flow_role_policy" {
  name = "${var.project}-${var.env}-vpc-flow-role-policy"
  role = aws_iam_role.vpc_flow_role.id

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
      "Resource": "*"
    }
  ]
}
EOF
}
