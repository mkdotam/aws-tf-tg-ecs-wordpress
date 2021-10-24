module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"

  name = "${var.project}-${var.env}-vpc"

  cidr = var.cidr_block
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  # database
  database_subnets             = var.database_subnets
  create_database_subnet_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_flow_log                                 = (var.env == "prod") ? true : false
  flow_log_max_aggregation_interval               = 60
  flow_log_cloudwatch_log_group_retention_in_days = 7
  flow_log_destination_type                       = "cloud-watch-logs"
  flow_log_cloudwatch_iam_role_arn                = aws_iam_role.vpc_flow_role.arn
  flow_log_destination_arn                        = aws_cloudwatch_log_group.vpc_flow.arn
  flow_log_cloudwatch_log_group_name_prefix       = "/vpc/flow/"

  tags = var.tags
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids         = module.vpc.private_subnets

  depends_on = [
    module.vpc
  ]
}
