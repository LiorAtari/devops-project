# Deploying ArgoCD server
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.8.15"
  namespace  = "argocd"
  depends_on = [
    kubernetes_namespace.argocd
  ]
}

# This chart is used to deploy applications 
resource "helm_release" "argocd-apps" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "2.0.2"
  namespace  = "argocd"
  values = [
    file("values/argocd-apps-values.yaml")
  ]
  depends_on = [
    helm_release.argocd,
    kubernetes_namespace.python-app,
    kubernetes_secret.devops-project-repo-ssh-key,
    kubernetes_secret.bitnami-repo,
    kubernetes_secret.mysql-secrets
  ]
}

# Creating the namespaces for ArgoCD and the Python app
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "python-app" {
  metadata {
    name = "python-app"
  }
}

#Creating K8s secret with the repo ssh key
resource "kubernetes_secret" "devops-project-repo-ssh-key" {
  metadata {
    name      = "devops-project-repo-ssh-key"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
    annotations = {
      "managed-by" = "argocd.argoproj.io"
    }
  }

  data = {
    name          = "devops-project"
    type          = "git"
    url           = "git@github.com:LiorAtari/devops-project.git"
    project       = "default"
    sshPrivateKey = data.google_secret_manager_secret_version.devops-project-repo-ssh-key.secret_data
  }

  type = "Opaque"
  depends_on = [
    kubernetes_namespace.argocd
  ]
}

#Creating K8s secret with the repo ssh key
resource "kubernetes_secret" "bitnami-repo" {
  metadata {
    name      = "bitnami-repo"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
    annotations = {
      "managed-by" = "argocd.argoproj.io"
    }
  }

  data = {
    name          = "bitnami-repo"
    type          = "helm"
    url           = "https://charts.bitnami.com/bitnami"
    project       = "default"
  }

  type = "Opaque"
  depends_on = [
    kubernetes_namespace.argocd
  ]
}



resource "kubernetes_secret" "mysql-secrets" {
  metadata {
    name      = "mysql-secrets"
    namespace = "python-app"
  }
  data = {
    mysql-root-password        = local.mysql_root_password_decoded
    mysql-password             = local.mysql_password_decoded
    mysql-replication-password = local.mysql_replication_password_decoded
  }
  type = "Opaque"
  depends_on = [
    kubernetes_namespace.python-app
  ]
}