provider "kubernetes" {
  alias = "eks-cluster"
  config_path = module.eks.kubeconfig
}

