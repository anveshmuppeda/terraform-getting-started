terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.9.0"
    }
  }
}

provider "kind" {
  # Configuration options
}

provider "kubernetes" {
  config_path = pathexpand(var.kubeconfig_path)
  config_context = var.k8s_context_name
}