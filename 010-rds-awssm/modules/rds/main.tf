data "aws_secretsmanager_secret" "rds_credentials" {
  name = "rds-credentials" # Ensure this matches the secret name created in the secretmanager module
}

data "aws_secretsmanager_secret_version" "rds_credentials_version" {
  secret_id = data.aws_secretsmanager_secret.rds_credentials.id
}

locals {
  rds_credentials_data = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials_version.secret_string)
}

resource "aws_db_instance" "my_first_db" {
  allocated_storage = 10
  db_name = var.db_name
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  username = local.rds_credentials_data.username
  password = local.rds_credentials_data.password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
  publicly_accessible = true
}