terraform {
    source = "../../../modules/kubernetes"
}

include {
    path = find_in_parent_folders()
}

dependency "eks"{
  config_path = "../eks"
}

inputs = {
  cluster_endpoint = dependency.eks.aws_eks_cluster.cluster.endpoint
  cluster_crt = dependency.eks.aws_eks_cluster.cluster.certificate_authority.0.data
  cluster_token = dependency.eks.aws_eks_cluster_auth.cluster.token
}