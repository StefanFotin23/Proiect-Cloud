provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = "app"
  }
}

# Node Labels
resource "kubernetes_node" "label_nodes" {
  for_each = toset(["worker1", "worker2", "master"])

  metadata {
    name = each.value
    labels = {
      role = each.value
    }
  }
}

# Output kubeconfig for debugging
output "kubeconfig" {
  value = "~/.kube/config"
}