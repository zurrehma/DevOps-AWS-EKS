module "argocd_helm" {
  source  = "lablabs/argocd/helm"
  version = "1.0.0"
#   helm_chart_version = "5.35.0"
  enabled           = true
  argo_enabled      = false
  argo_helm_enabled = false

  self_managed = false

  helm_release_name = "argocd"
  namespace         = "argocd"

  helm_timeout = 300
  helm_wait    = true
}
