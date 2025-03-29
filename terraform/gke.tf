# Creating GCP GKE cluster
resource "google_container_cluster" "lior-cluster" {
  name     = var.cluster_name
  location = var.region
  project  = var.project

  network    = google_compute_network.lior-vpc-network.name
  subnetwork = google_compute_subnetwork.lior-subnetwork.name


  remove_default_node_pool = true
  initial_node_count       = 1
}

# Creating a custom node pool
resource "google_container_node_pool" "app-node-pool" {
  name       = "app-node-pool"
  location = var.region
  project  = var.project
  cluster    = google_container_cluster.lior-cluster.name
  node_count = 1
  # Creating a spot node pool
  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# Creating the application's namespace
resource "kubernetes_namespace" "application" {
  metadata {
    name = "develeap-python-app"
  }
  depends_on = [ 
    google_container_cluster.lior-cluster
   ]
}

# Creating the ArgoCD namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  depends_on = [ 
    google_container_cluster.lior-cluster
   ]
}