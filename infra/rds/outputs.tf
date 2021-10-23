output "db_secrets_arn" {
  value = aws_secretsmanager_secret_version.db_secrets_values.arn
}
