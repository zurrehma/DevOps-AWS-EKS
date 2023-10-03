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
