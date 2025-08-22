output "rds_endpoint" {
  value = aws_db_instance.nadine_mysql.address
}

output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_secret.arn
}
