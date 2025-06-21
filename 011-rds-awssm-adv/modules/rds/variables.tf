variable "db_name" {
  description = "The name of the RDS database."
  type        = string
  default     = "mydatabase"
}
variable "secret_manager_name" {
  description = "The name of the AWS Secrets Manager secret for RDS credentials."
  type        = string
  default     = "rds-db-credentials"
}