resource "aws_secretsmanager_secret" "db_secret" {
  name = "nadine-secret-2"
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "nadineuser"
    password = "Nadine1234"  # Only ASCII printable characters
  })
}
