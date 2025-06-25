variable "cluster_name" {
  description = "The name of the KIND cluster."
  type        = string
  default     = "terraform-kind-cluster"
}

variable "kubeconfig_path" {
  description = "The path to the kubeconfig file for the KIND cluster."
  type        = string
  default     = "~/.kube/config"
}
