terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.27.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

resource "google_project" "develeap-task" {
  name       = var.project
  project_id = var.project
}

# Enabling APIs required which are not enabled by default
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  project = var.project
  disable_on_destroy = false
}

resource "google_project_service" "kubernetes" {
  service = "container.googleapis.com"
  project = var.project
  disable_on_destroy = false
}

resource "google_project_service" "secret_manager" {
  service = "secretmanager.googleapis.com"
  project = var.project
  disable_on_destroy = false
}