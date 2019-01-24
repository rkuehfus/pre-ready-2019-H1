provider "kubernetes" {

  host                   = "${azurerm_kubernetes_cluster.akscluster.kube_config.0.host}"
  username               = "${azurerm_kubernetes_cluster.akscluster.kube_config.0.username}"
  password               = "${azurerm_kubernetes_cluster.akscluster.kube_config.0.password}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.akscluster.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.akscluster.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.akscluster.kube_config.0.cluster_ca_certificate)}"

  }

resource "kubernetes_namespace" "example" {
  metadata {
    name = "${var.namespace}"
  }
}

resource "kubernetes_pod" "web" {
  metadata {
    name = "nginx"

    labels {
      name = "nginx"
    }

    namespace = "${kubernetes_namespace.example.metadata.0.name}"
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "nginx"
    }
  }
}

resource "kubernetes_service" "web" {
  metadata {
    name      = "nginx"
    namespace = "${kubernetes_namespace.example.metadata.0.name}"
  }

  spec {
    selector {
      name = "${kubernetes_pod.web.metadata.0.labels.name}"
    }

    session_affinity = "ClientIP"

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}