variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default = "rds_demo_vpc"
}
variable "security_group_name" {
  description = "The name of the security group for the RDS instance."
  type        = string
  default     = "rds_security_group_demo"
}