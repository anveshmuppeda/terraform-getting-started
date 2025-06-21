variable "name" {
  description = "The name of the secret."
  type        = string
  default     = "my-rds-credentials"
}
variable "username" {
  description = "The username for the RDS database."
  type        = string
  default     = "admin"
}
variable "password" {
  description = "The password for the RDS database."
  type        = string
  default     = "" # Replace with a secure password
  sensitive   = true
}