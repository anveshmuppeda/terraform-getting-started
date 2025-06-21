resource "aws_secretsmanager_secret" "rds_credentials" {
  name        = var.name
  description = "RDS credentials for the application"
}

resource "aws_secretsmanager_secret_version" "rds_credentials_version" {
    secret_id     = aws_secretsmanager_secret.rds_credentials.id
    secret_string = jsonencode({
        username = var.username
        password = var.password
    })
}