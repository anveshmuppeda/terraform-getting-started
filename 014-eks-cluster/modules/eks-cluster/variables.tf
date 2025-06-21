variable "eks_cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}
variable "eks_cluster_role_name" {
  description = "The name of the IAM role for the EKS cluster."
  type        = string
  default     = "my-eks-cluster-role"
}
variable "eks_subnet_ids" {
  description = "List of subnet IDs for the EKS cluster."
  type        = list(string)
  default     = []
}