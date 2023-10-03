# Wait for the EKS cluster to be created before proceeding
resource "null_resource" "wait_for_eks" {
  depends_on = [module.eks]
  
  # Use a local-exec provisioner to run a command that waits for the cluster to be ready
  provisioner "local-exec" {
    command = "sleep 60" # Replace with a command that checks EKS readiness
  }
}

provider "kubernetes" {
  # alias = "eks-cluster"
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_crt)
  token                  = var.cluster_token
}
provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_crt)
    token                  = var.cluster_token
  }
}


# provider "helm" {
#   kubernetes {
#     # alias = "eks-cluster"
#     host                   = data.aws_eks_cluster.cluster.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#     token                  = data.aws_eks_cluster_auth.cluster.token
#   }
# }




