resource "aws_secretsmanager_secret" "rds_credentials" {
  name        = var.name
  description = "RDS credentials for the application"
}

resource "random_password" "random_password_generator" {
  length  = 16
  special = true
  override_special = "!@#$%^&*()-_=+[]{}|;:,.<>?/"
}

# data "aws_secretsmanager_random_password" "rds_credentials" {
#   password_length = 16
#   exclude_characters = "\"'`\\"
#   exclude_numbers = false
#   exclude_uppercase = false
# }

resource "aws_secretsmanager_secret_version" "rds_credentials_version" {
    secret_id     = aws_secretsmanager_secret.rds_credentials.id
    secret_string = jsonencode({
        username = var.username
        # password = data.aws_secretsmanager_random_password.rds_credentials.random_password
        password = random_password.random_password_generator.result
    })
}
