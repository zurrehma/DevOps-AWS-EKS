resource "kubernetes_cluster_role" "k8s-dev" {
  metadata {
    name = "k8s-dev"
  }

  rule {
    api_groups = ["*"]
    resources  = ["deployments", "configmaps", "pods", "secrets", "services", "pods/log"]
    verbs      = ["get", "list", "watch"]
  }
}
resource "kubernetes_cluster_role_binding" "k8s-dev" {
  metadata {
    name = "k8s-dev"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "k8s-dev"
  }
  subject {
    kind      = "User"
    name      = "k8s-dev"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "Group"
    name      = "k8s-dev"
    api_group = "rbac.authorization.k8s.io"
  }
}