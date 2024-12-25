terraform {
  backend "gcs" {
    bucket = "tf-gke"
    prefix = "terraform/state"
  }
}
