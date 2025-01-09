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

  docker_username = var.docker_username
  docker_repo     = var.docker_repo
}

module "auth" {
  source = "./kubernetes/auth"

  docker_username = var.docker_username
  docker_repo     = var.docker_repo
}

module "backend" {
  source = "./kubernetes/backend"

  docker_username = var.docker_username
  docker_repo     = var.docker_repo
}

module "auth_database" {
  source = "./kubernetes/databases"

  database_name  = "auth-database"
  docker_username = var.docker_username
  docker_repo     = var.docker_repo
}

module "backend_database" {
  source = "./kubernetes/databases"

  database_name  = "backend-database"
  docker_username = var.docker_username
  docker_repo     = var.docker_repo
}

module "auth_adminer" {
  source = "./kubernetes/adminer"

  database_name   = "auth-database"
  adminer_port    = 8088
}

module "backend_adminer" {
  source = "./kubernetes/adminer"

  database_name   = "backend-database"
  adminer_port    = 8087
}
