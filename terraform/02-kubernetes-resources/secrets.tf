data "google_secret_manager_secret_version" "devops-project-repo-ssh-key" {
  secret  = "devops-project-repo-ssh-key" # name of the secret in Secret Manager
  project = var.project
  version = "latest"
}

data "google_secret_manager_secret_version" "mysql_secrets" {
  secret  = "mysql-secrets"
  project = var.project
}
# Secret is saved in GCP Secret Manager as JSON
locals {
  mysql_secret_json = jsondecode(data.google_secret_manager_secret_version.mysql_secrets.secret_data)

  mysql_root_password_decoded        = base64encode(local.mysql_secret_json["mysql-root-password"])
  mysql_password_decoded             = base64encode(local.mysql_secret_json["lior"])
  mysql_replication_password_decoded = base64encode(local.mysql_secret_json["mysql-replication-password"])
}