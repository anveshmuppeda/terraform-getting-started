locals {
  k8s_config_path = pathexpand(var.kubeconfig_path)
}

resource "kind_cluster" "kind_terraform_cluster" {
  name           = var.kind_cluster_name
  kubeconfig_path = local.k8s_config_path
  wait_for_ready = true

  # Optional: Specify additional configuration options
  # like node image, network settings, etc.
  
}

resource "helm_release" "nginx_helm_release" {
  name       = var.deployment_name
  chart      = "./nginx-chart" # Path to your Helm chart
  namespace  = var.namespace

  set = [
    {
      name  = "replicaCount"
      value = "2"
    },
    {
      name  = "service.type"
      value = "ClusterIP"
    }
  ]

  depends_on = [kind_cluster.kind_terraform_cluster]
  
}

output "kind_cluster_name" {
  value = "Kind Cluster Name: ${kind_cluster.kind_terraform_cluster.name}"
  
}