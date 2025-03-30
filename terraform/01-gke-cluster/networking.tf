# Creating VPC network
resource "google_compute_network" "lior-vpc-network" {
  name                    = "lior-vpc-network"
  project                 = var.project
  auto_create_subnetworks = false
}

# Creating subnets for the VPC network
resource "google_compute_subnetwork" "lior-subnetwork" {
  name          = "lior-subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.lior-vpc-network.id
}