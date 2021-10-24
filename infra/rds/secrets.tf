data "aws_caller_identity" "current" {}

locals {
  db_secrets = {
    "host"                 = module.rds.rds_cluster_endpoint,
    "port"                 = module.rds.rds_cluster_port,
    "username"             = module.rds.rds_cluster_master_username,
    "database"             = module.rds.rds_cluster_database_name,
    "password"             = module.rds.rds_cluster_master_password,
    "engine"               = module.rds.rds_cluster_engine_version,
    "dbClusterIdentifier"  = module.rds.rds_cluster_id,
    "dbInstanceIdentifier" = module.rds.rds_cluster_id
  }
}

resource "aws_secretsmanager_secret" "db_secrets" {
  name        = "${var.env}/rds-db-credentials/${module.rds.rds_cluster_resource_id}"
  description = "Secrets to connect to RDS Aurora"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "db_secrets_values" {
  secret_id     = aws_secretsmanager_secret.db_secrets.name
  secret_string = jsonencode(local.db_secrets)
}

data "aws_iam_policy_document" "db_secrets_policy_document" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [aws_secretsmanager_secret_version.db_secrets_values.arn]
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_secretsmanager_secret_policy" "db_secrets" {
  secret_arn = aws_secretsmanager_secret.db_secrets.arn
  policy     = data.aws_iam_policy_document.db_secrets_policy_document.json
}