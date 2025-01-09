resource "kubernetes_namespace" "database" {
  metadata {
    name = var.database_name
  }
}

resource "kubernetes_deployment" "database" {
  metadata {
    name      = var.database_name
    namespace = kubernetes_namespace.database.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.database_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.database_name
        }
      }

      spec {
        container {
          name  = "${var.database_name}-container"
          image = "${var.docker_username}/${var.docker_repo}-${var.database_name}"

          env {
            name  = "MYSQL_DATABASE"
            value = "auth"  # Change if needed (make it dynamic if required)
          }

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "root"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "database_service" {
  metadata {
    name      = var.database_name
    namespace = kubernetes_namespace.database.metadata[0].name
  }

  spec {
    selector = {
      app = var.database_name
    }

    port {
      port        = 3306
      target_port = 3306
    }
  }
}