resource "random_password" "rds_password" {
  length  = 16
  special = true
  override_special = "!@#$%^&*()-_=+[]{}|;:,.<>?/"
}

resource "aws_secretsmanager_secret" "rds_secret" {
  name        = var.aws_sm_name
  description = "RDS credentials secret"
}

resource "aws_db_subnet_group" "rds_subnet_groups" {
  name       = "${var.rds_db_instance_identifier}-subnet-group"
  subnet_ids = var.rds_subnet_groups

  tags = {
    Name = "${var.rds_db_instance_identifier}-subnet-group"
  }
}

resource "aws_db_instance" "rds_cluster_demo" {
  allocated_storage = 10
  engine = var.rds_engine
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  username = var.rds_username
  password = random_password.rds_password.result
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
  publicly_accessible = true
  vpc_security_group_ids = var.rds_security_group_ids
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_groups.name
  db_name = var.db_name
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
    secret_string = jsonencode({
        username = aws_db_instance.rds_cluster_demo.username
        password = aws_db_instance.rds_cluster_demo.password
        engine   = var.rds_engine
        host     = aws_db_instance.rds_cluster_demo.address
        port     = 3306
        dbname   = var.db_name
    }
  )
}

output "secretsmanager_id" {
  description = "Value of AWS SM ID"
  value = aws_secretsmanager_secret.rds_secret.id
}

output "secretsmanager_arn" {
  description = "Value of AWS SM arn"
  value = aws_secretsmanager_secret.rds_secret.arn
}