provider "kubernetes" {
  alias = "eks-cluster"
  config_path = "cluster.yaml"  
}

