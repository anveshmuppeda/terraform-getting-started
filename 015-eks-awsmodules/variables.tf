variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}
variable "cluster_version" {
  description = "The version of the EKS cluster."
  type        = string
  default     = "1.32"
}
variable "subnets" {
  description = "The subnets to use for the EKS cluster."
  type        = list(string)
  default     = []
}
variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
  default     = ""
}