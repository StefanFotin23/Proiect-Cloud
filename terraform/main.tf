terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "kubernetes" {
  config_path = "~/.kube/config" # Path to your kubeconfig file
}

module "namespaces" {
  source = "./kubernetes/namespaces"
}

module "frontend" {
  source = "./kubernetes/frontend"
}

module "auth" {
  source = "./kubernetes/auth"
}

module "backend" {
  source = "./kubernetes/backend"
}

module "databases" {
  source = "./kubernetes/databases"
}

module "adminer" {
  source = "./kubernetes/adminer"
}
