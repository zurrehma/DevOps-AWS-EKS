terraform {
    source = "../../../modules/argocd"
}

include {
    path = find_in_parent_folders()
}

dependency "eks"{
  config_path = "../k8s"
  skip_outputs   = true
}

inputs = {
  cluster_arn = dependency.eks.outputs.context.cluster_arn
  cluster_endpoint = dependency.eks.outputs.context.cluster_endpoint
  cluster_crt = dependency.eks.outputs.context.cluster_certificate_authority_data
  cluster_name = dependency.eks.outputs.context.cluster_name
}
# inputs = {
#   cluster_id = dependency.eks.outputs.context.cluster_id
#   jenkins_admin_user = local.common_vars.locals.jenkins_admin_user
#   jenkins_admin_password = local.common_vars.locals.jenkins_admin_password
#   namespace_name = local.common_vars.locals.jenkins_namespace_name
# }