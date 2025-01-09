resource "kubernetes_deployment" "auth_database" {
  metadata {
    name      = "auth-database"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "auth-database"
      }
    }

    template {
      metadata {
        labels = {
          app = "auth-database"
        }
      }

      spec {
        container {
          name  = "auth-database"
          image = var.mysql_image

          env {
            name  = "MYSQL_DATABASE"
            value = "auth"
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

resource "kubernetes_service" "auth_database_service" {
  metadata {
    name      = "auth-database"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }

  spec {
    selector = {
      app = "auth-database"
    }

    port {
      port        = 3306
      target_port = 3306
    }
  }
}
