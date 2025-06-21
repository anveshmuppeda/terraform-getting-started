module "secretmanager" {
  source = "./modules/secretmanager"
  name   = "rds-db-credentials"
  username = "admin"
  password = "" # Replace with a secure password
}

module "rdsinstance" {
  depends_on = [ module.secretmanager ]
  source = "./modules/rds"
  db_name = "mydb"
  secret_manager_name = "rds-db-credentials"
}