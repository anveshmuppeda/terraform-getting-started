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

resource "kubernetes_deployment" "nginx_deployment" {
  metadata {
    name      = var.deployment_name
    namespace = var.namespace
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name      = "nginx-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = kubernetes_deployment.nginx_deployment.spec[0].template[0].metadata[0].labels["app"]
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
  
}

output "deployment_name" {
  value = " Nginx deployment name: ${ kubernetes_deployment.nginx_deployment.metadata[0].name } in namespace ${ kubernetes_deployment.nginx_deployment.metadata[0].namespace }"
}

output "portforwarding_command" {
  value = "kubectl port-forward service/nginx-service 8080:80 -n ${kubernetes_deployment.nginx_deployment.metadata[0].namespace}"
}