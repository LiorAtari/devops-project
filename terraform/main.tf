terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.27.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre2"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

provider "helm" {
  kubernetes = {
    host                   = "https://${google_container_cluster.lior-cluster.endpoint}"
    cluster_ca_certificate = base64decode(google_container_cluster.lior-cluster.master_auth[0].cluster_ca_certificate)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gke-gcloud-auth-plugin"
    }
  }
}