module "rds" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "5.2.0"

  name              = "${var.project}-${var.env}-aurora-db"
  engine            = "aurora-mysql"
  engine_mode       = "serverless"
  engine_version    = "5.7"
  storage_encrypted = true
  database_name     = replace("${var.project}_${var.env}", "-", "_")

  vpc_id                = var.vpc_id
  subnets               = var.database_subnets
  create_security_group = true
  allowed_cidr_blocks   = var.private_cidr_blocks

  replica_scale_enabled = false
  replica_count         = 0

  deletion_protection  = (var.env == "prod") ? true : false
  apply_immediately    = (var.env == "prod") ? false : true
  enable_http_endpoint = (var.env == "prod") ? false : true

  performance_insights_enabled = true
  monitoring_interval          = 10

  db_parameter_group_name         = aws_db_parameter_group.mysql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.mysql.id
  # enabled_cloudwatch_logs_exports = ["general", "audit", "error", "slowquery"] # NOT SUPPORTED

  scaling_configuration = {
    auto_pause               = true
    min_capacity             = 1
    max_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }

  tags = var.tags
}


resource "aws_db_parameter_group" "mysql" {
  name        = "${var.project}-${var.env}-db-parameter-group"
  description = "${var.project}-${var.env}-db-parameter-group"
  family      = "aurora-mysql5.7"
  tags        = var.tags
}

resource "aws_rds_cluster_parameter_group" "mysql" {
  name        = "${var.project}-${var.env}-cluster-parameter-group"
  description = "${var.project}-${var.env}-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  tags        = var.tags
}