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
  cluster_arn       = dependency.eks.outputs.context.cluster_arn
  cluster_endpoint  = dependency.eks.outputs.context.cluster_endpoint
  cluster_crt       = dependency.eks.outputs.context.cluster_certificate_authority_data
  cluster_name      = dependency.eks.outputs.context.cluster_name
  aws_auth          = dependency.eks.outputs.context.aws_auth_configmap_yaml
}
