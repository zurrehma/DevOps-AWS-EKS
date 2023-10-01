provider "kubernetes" {
  alias = "eks-cluster"
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}
# resource "kubernetes_manifest" "argocd" {
#   manifest = file("${path.module}/argocd.yaml")
# }




