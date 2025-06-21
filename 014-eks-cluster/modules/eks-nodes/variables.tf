variable "eks_cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}
variable "eks_subnet_ids" {
  description = "List of subnet IDs for the EKS cluster."
  type        = list(string)
  default     = []
}
variable "eks_node_role_name" {
  description = "The name of the IAM role for the EKS nodes."
  type        = string
  default     = "my-eks-node-role"
}
variable "eks_node_group_name" {
  description = "The name of the EKS node group."
  type        = string
  default     = "my-eks-node-group"
}
variable "eks_node_instance_type" {
  description = "The type of instance to use for the EKS nodes."
  type        = string
  default     = "t3.medium"
}
variable "eks_node_desired_capacity" {
  description = "The desired number of EKS nodes."
  type        = number
  default     = 2
}
variable "eks_node_max_size" {
  description = "The maximum number of EKS nodes."
  type        = number
  default     = 3
}
variable "eks_node_min_size" {
  description = "The minimum number of EKS nodes."
  type        = number
  default     = 1
}