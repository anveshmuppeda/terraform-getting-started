variable "vpc_id" {
  description = "VPC ID"
  type = string
  default = ""
}
variable "rds_subnet_groups" {
  description = "The subnet groups for the RDS DB instance."
  type        = list(string)
  default     = []
}
variable "rds_security_group_ids" {
  description = "The security group ids"
  type = list(string)
  default = []
}
variable "secretsmanager_id" {
  description = "AWS SM ID"
  type = string
  default = ""
}
variable "secretsmanager_arn" {
  description = "AWS SM Arn"
  type = string
  default = ""
}