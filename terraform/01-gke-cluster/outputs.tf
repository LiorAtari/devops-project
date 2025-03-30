output "endpoint" {
  value = google_container_cluster.lior-cluster.endpoint
}

output "ca_certificate" {
  value = google_container_cluster.lior-cluster.master_auth[0].cluster_ca_certificate
  # Preventing the output from printing in terminal
  sensitive = true
}

output "name" {
  value = google_container_cluster.lior-cluster.name
}

output "location" {
  value = google_container_cluster.lior-cluster.location
}