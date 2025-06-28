variable "rds_db_instance_identifier" {
  description = "The identifier of the RDS DB instance."
  type        = string
  default = "demo_rds_instance"
}
variable "rds_secret_name" {
  description = "The name of the RDS secret in AWS Secrets Manager."
  type        = string
  default     = "rds-credentials"
}
