# Define the namespace for the frontend service
resource "kubernetes_namespace" "frontend" {
  metadata {
    name = "frontend"
  }
}

# Define the deployment for the frontend service
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.frontend.metadata[0].name
  }

  spec {
    replicas = 2  # Adjust the number of replicas as needed

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          name  = "frontend-container"
          image = "your-frontend-image"  # Replace with your frontend Docker image
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# Define the service for the frontend service
resource "kubernetes_service" "frontend_service" {
  metadata {
    name      = "frontend-service"
    namespace = kubernetes_namespace.frontend.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.frontend.metadata[0].name
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"  # Change this to ClusterIP, NodePort, or LoadBalancer as needed
  }
}
