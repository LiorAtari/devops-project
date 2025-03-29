# Deploying ArgoCD server
resource "helm_release" "arogcd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.8.15"
  namespace        = "argocd"
  values = [
    file("values/argocd-values.yaml")
  ]
  depends_on = [
    google_container_cluster.lior-cluster
  ]
}

# This chart is used to deploy applications 
resource "helm_release" "argocd-apps" {
  name = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argocd-apps"
  version = "2.0.2"
  namespace = "argocd"
  create_namespace = false
  values = [
    file("values/argocd-apps-values.yaml")
  ]
  depends_on = [
    helm_release.argocd
  ]
}