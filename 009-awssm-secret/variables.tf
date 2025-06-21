variable "amiid" {
  description = "The ID of the AMI to use for the EC2 instance."
  type        = string 
  default     = "" # Replace with a valid AMI ID for your region
}
variable "instance_type" {
  description = "The type of instance to create."
  type        = string
  default     = "t2.micro"
}
variable "securitygroupname" {
  description = "The name of the security group to create."
  type        = string
  default     = "MySecurityGroup"
}