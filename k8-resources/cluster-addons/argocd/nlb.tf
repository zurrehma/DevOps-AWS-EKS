resource "kubernetes_manifest" "application_cluster_addons_nlb_" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "Application"
    "metadata" = {
      "name" = "cluster-addons(nlb)"
    }
    "spec" = {
      "destination" = {
        "name" = ""
        "namespace" = "ingress-nginx"
        "server" = "https://kubernetes.default.svc"
      }
      "project" = "default"
      "source" = {
        "path" = "./k8-resources/cluster-addons"
        "repoURL" = "git@github.com:EatWithAva/dvelop-infrastructure.git"
        "targetRevision" = "master"
      }
      "syncPolicy" = {
        "automated" = {
          "prune" = true
          "selfHeal" = true
        }
        "syncOptions" = [
          "CreateNamespace=true",
          "ApplyOutOfSyncOnly=true",
        ]
      }
    }
  }
}
