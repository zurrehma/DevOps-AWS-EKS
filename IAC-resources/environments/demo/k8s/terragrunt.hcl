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
  cluster_id = dependency.eks.outputs.context.cluster_id
  # cluster_endpoint = dependency.eks.outputs.cluster_endpoint
  # cluster_crt = dependency.eks.outputs.cluster_certificate_authority_data
  # cluster_token = dependency.eks.outputs.aws_eks_cluster_auth.cluster.token
}
# inputs = {
#   cluster_id = dependency.eks.outputs.context.cluster_id
#   jenkins_admin_user = local.common_vars.locals.jenkins_admin_user
#   jenkins_admin_password = local.common_vars.locals.jenkins_admin_password
#   namespace_name = local.common_vars.locals.jenkins_namespace_name
# }