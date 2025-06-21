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
variable "instance_name" {
  description = "The name tag for the EC2 instance."
  type        = string
  default     = "MyFirstInstance2"
}
variable "private_key_path" {
  description = "Path to the private key file for SSH access to the EC2 instance."
  type        = string
  default     = "~/.ssh/id_rsa" # Default path, can be changed if needed 
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access to the EC2 instance."
  type        = string
  default     = "" # Replace with a valid key pair name if needed
}