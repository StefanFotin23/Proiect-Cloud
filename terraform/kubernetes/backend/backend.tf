resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.backend.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          name  = "backend-container"
          image = "${var.docker_username}/${var.docker_repo}-backend"

          port {
            container_port = 8082
          }

          env {
            name  = "SERVER_PORT"
            value = "8082"
          }

          env {
            name  = "DB_URL"
            value = "jdbc:mysql://backend-database:3306/backend"
          }
        }
      }
    }
  }
}

# Define the namespace for the backend service
resource "kubernetes_namespace" "backend" {
  metadata {
    name = "backend"
  }
}

output "service_name" {
  value = kubernetes_service.backend_service.metadata[0].name
}

resource "kubernetes_service" "backend_service" {
  metadata {
    name      = "backend-service"
    namespace = kubernetes_namespace.backend.metadata[0].name
  }

  spec {
    selector = {
      app = "backend"
    }

    port {
      port        = 8082
      target_port = 8082
    }
  }
}
