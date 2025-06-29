variable "server_name" {
  description = "Windows Server Name"
  type = string
  default = "windows-demo"
}
variable "windows_amiid" {
  description = "Windows Server AMI ID"
  type = string
  default = "ami-02b60b5095d1e5227"
}
variable "key_name" {
  description = "Windows Pem Key"
  type = string
  default = "win"
}
variable "win_iam_role_name" {
  description = "Windows CloudWatch IAM Role Name"
  type = string
  default = "Windows-CloudWatch-IAM-Role"
}