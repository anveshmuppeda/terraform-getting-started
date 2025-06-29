# variables.tf
variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "your-key-pair"
}

variable "mysql_root_password" {
  description = "MySQL root password"
  type        = string
  sensitive   = true
  default     = "YourSecurePassword123!"
}

variable "app_db_password" {
  description = "Application database user password"
  type        = string
  sensitive   = true
  default     = "AppPassword123!"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type = string
  default = "ami-020cba7c55df1f615"
}