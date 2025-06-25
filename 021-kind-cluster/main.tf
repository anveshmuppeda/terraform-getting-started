locals {
  k8s_config_path = pathexpand(var.kubeconfig_path)
}

resource "kind_cluster" "kind_terraform_cluster" {
    name = var.cluster_name
    
    kubeconfig_path = local.k8s_config_path
    wait_for_ready = true
    
    # Optional: Specify additional configuration options
    # like node image, network settings, etc.
  
}

output "kind_cluster_status" {
  value = "Cluster ${kind_cluster.kind_terraform_cluster.name} is created successfully."
}