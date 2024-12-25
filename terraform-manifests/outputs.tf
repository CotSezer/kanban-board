output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = google_container_cluster.primary.endpoint
}

output "app_service_ip" {
  description = "The external IP address of the application service"
  value       = kubernetes_service.app_service.status[0].load_balancer[0].ingress[0].ip
}
