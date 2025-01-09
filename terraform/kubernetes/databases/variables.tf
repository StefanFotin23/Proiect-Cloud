variable "docker_username" {
  description = "Docker username for the image repository"
  type        = string
}

variable "docker_repo" {
  description = "Docker repository name for the frontend image"
  type        = string
}

variable "database_name" {
  description = "Name of the database (e.g., auth-database or backend-database)"
  type        = string
}