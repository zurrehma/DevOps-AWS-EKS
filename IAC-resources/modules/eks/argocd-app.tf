resource "kubernetes_manifest" "secret_argocd_private_repo" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Secret"
    "metadata" = {
      "labels" = {
        "argocd.argoproj.io/secret-type" = "repository"
      }
      "name" = "private-repo"
      "namespace" = "argocd"
    }
    "stringData" = {
      "name" = "private-repo"
      "project" = "default"
      "sshPrivateKey" = <<-EOT
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
    QyNTUxOQAAACDnuAClvVlIhyCci+gjkWC5OA/+68A24sd0otSeaTtwYQAAAJD15F1d9eRd
    XQAAAAtzc2gtZWQyNTUxOQAAACDnuAClvVlIhyCci+gjkWC5OA/+68A24sd0otSeaTtwYQ
    AAAEBrPF735Nf/m4HTE6WSBRsy4OZViZ1kZsKVtZwkwkmq4ue4AKW9WUiHIJyL6CORYLk4
    D/7rwDbix3Si1J5pO3BhAAAADGluZnJhQGFyZ29jZAE=
    -----END OPENSSH PRIVATE KEY-----
      
      EOT
      "type" = "git"
      "url" = "git@github.com:EatWithAva/dvelop-infrastructure.git"
    }
  }
}

# resource "kubernetes_manifest" "application_argocd_ava_server" {
#   manifest = {
#     "apiVersion" = "argoproj.io/v1alpha1"
#     "kind" = "Application"
#     "metadata" = {
#       "name" = "ava-server"
#       "namespace" = "argocd"
#     }
#     "spec" = {
#       "destination" = {
#         "name" = ""
#         "namespace" = "ava-server"
#         "server" = "https://kubernetes.default.svc"
#       }
#       "project" = "default"
#       "source" = {
#         "directory" = {
#           "recurse" = true
#         }
#         "path" = "./k8-resources/app-deployments"
#         "repoURL" = "git@github.com:EatWithAva/dvelop-infrastructure.git"
#         "targetRevision" = "master"
#       }
#       "sources" = []
#       "syncPolicy" = {
#         "syncOptions" = [
#           "CreateNamespace=true",
#         ]
#       }
#     }
#   }
# }