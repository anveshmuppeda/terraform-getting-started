variable "aws_sm_name" {
  description = "The name of the AWS Secrets Manager secret."
  type        = string
  default     = "rds-credentials"
}
variable "rds_db_instance_identifier" {
  description = "The identifier of the RDS DB instance."
  type        = string
  default     = "demo_rds_instance"
}
variable "rds_username" {
  description = "The username for the RDS DB instance."
  type        = string
  default     = "admin"
}
variable "rds_engine" {
  description = "The database engine for the RDS DB instance."
  type        = string
  default     = "mysql"
}
variable "rds_subnet_groups" {
  description = "The subnet groups for the RDS DB instance."
  type        = list(string)
  default     = []
}
variable "rds_security_group_ids" {
  description = "The security group ids"
  type = list(string)
  default = [ ]
}