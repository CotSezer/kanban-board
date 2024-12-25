provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  client_certificate     = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
  client_key             = base64decode(google_container_cluster.primary.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  deletion_protection = false

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = 30  # Reduce disk size
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }

  initial_node_count = 1
} 

resource "google_container_node_pool" "primary_nodes" {
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  node_count = 1
    
  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = 30  # Reduce disk size
    preemptible  = false

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}


resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = var.namespace
  }

  # Ensure namespace is created after the GKE cluster
  depends_on = [google_container_cluster.primary]
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          name  = var.app_name
          image = var.docker_image

          # Correct use of ports (plural)
          port {
            container_port = var.container_port
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }

            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app_service" {
  metadata {
    name      = "${var.app_name}-service"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }

  spec {
    selector = {
      app = var.app_name
    }

    type = "LoadBalancer"

    # Correct use of ports (plural)
    port {
      port        = var.service_port
      target_port = var.container_port
    }
  }
}
