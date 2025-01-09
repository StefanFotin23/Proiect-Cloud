output "frontend_service_url" {
  value = module.frontend.kubernetes_service.frontend_service.metadata[0].name
}

output "auth_service_url" {
  value = module.auth.kubernetes_service.auth_service.metadata[0].name
}

output "backend_service_url" {
  value = module.backend.kubernetes_service.backend_service.metadata[0].name
}
