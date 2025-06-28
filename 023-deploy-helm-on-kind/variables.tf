variable "kind_cluster_name" {
  description = "Name of the Kind cluster to deploy the pod on"
  type        = string
  default     = "terraform-kind-cluster"
}
variable "kubeconfig_path" {
  description = "Path to the kubeconfig file for the Kind cluster"
  type        = string
  default     = "~/.kube/config"
}
variable "k8s_context_name" {
  description = "Kubernetes context name for the Kind cluster"
  type        = string
  default     = "kind-terraform-kind-cluster"
}
variable "deployment_name" {
  description = "Name of the Kubernetes deployment"
  type        = string
  default     = "nginx-deployment"
}
variable "namespace" {
  description = "Namespace for the Kubernetes resources"
  type        = string
  default     = "default"
}