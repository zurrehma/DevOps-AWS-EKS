resource "kubernetes_manifest" "application_argocd_ava_server" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "Application"
    "metadata" = {
      "name" = "ava-server"
      "namespace" = "argocd"
    }
    "spec" = {
      "destination" = {
        "name" = ""
        "namespace" = "ava-server"
        "server" = "https://kubernetes.default.svc"
      }
      "project" = "default"
      "source" = {
        "directory" = {
          "recurse" = true
        }
        "path" = "./deployments/app"
        "repoURL" = "git@github.com:EatWithAva/dvelop-infrastructure.git"
        "targetRevision" = "master"
      }
      "sources" = []
      "syncPolicy" = {
        "syncOptions" = [
          "CreateNamespace=true",
        ]
      }
    }
  }
}
