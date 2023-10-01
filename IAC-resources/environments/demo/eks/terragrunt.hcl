terraform {
    source = "../../../modules/eks"
}

include {
    path = find_in_parent_folders()
}

dependency "vpc"{
  config_path = "../vpc"
}
locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("account.yaml"))
}
inputs = {
  vpc_id = dependency.vpc.outputs.context.vpc_id
  subnets = dependency.vpc.outputs.context.private_subnets
  aws-rols = local.common_vars.aws-users
}