module "secretmanager" {
  source = "./modules/secretmanager"
  name   = "rds-credentials"
  username = "admin"
  password = "" # Replace with a secure password
}

module "rdsinstance" {
  source = "./modules/rds"
  db_name = "mydb"
}