variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Region for the GKE cluster"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "next-app-cluster"
}

variable "node_machine_type" {
  description = "Machine type for nodes"
  type        = string
  default     = "e2-medium"
}

variable "initial_node_count" {
  description = "Initial node count for the cluster"
  type        = number
  default     = 3
}

variable "node_pool_size" {
  description = "Number of nodes in the node pool"
  type        = number
  default     = 3
}

variable "namespace" {
  description = "Kubernetes namespace for the app"
  type        = string
  default     = "kanban-board"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "kanban-board"
}

variable "docker_image" {
  description = "Docker image URL from Docker Hub"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 3000
}

variable "service_port" {
  description = "Port exposed by the service"
  type        = number
  default     = 80
}

variable "replicas" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 3
}
