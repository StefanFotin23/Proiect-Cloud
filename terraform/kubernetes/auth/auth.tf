resource "kubernetes_deployment" "auth" {
  metadata {
    name      = "auth"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "auth"
      }
    }

    template {
      metadata {
        labels = {
          app = "auth"
        }
      }

      spec {
        container {
          name  = "auth-container"
          image = "${var.docker_username}/${var.docker_repo}-auth"

          port {
            container_port = 8080
          }

          env {
            name  = "SERVER_PORT"
            value = "8080"
          }

          env {
            name  = "DB_URL"
            value = "jdbc:mysql://auth-database:3306/auth"
          }
        }
      }
    }
  }
}

# Define the namespace for the auth service
resource "kubernetes_namespace" "auth" {
  metadata {
    name = "auth"
  }
}

output "service_name" {
  value = kubernetes_service.auth_service.metadata[0].name
}

resource "kubernetes_service" "auth_service" {
  metadata {
    name      = "auth-service"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }

  spec {
    selector = {
      app = "auth"
    }

    port {
      port        = 8080
      target_port = 8080
    }
  }
}
