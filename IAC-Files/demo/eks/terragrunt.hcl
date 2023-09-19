terraform {
    source = "../../modules/eks"
}

include {
    path = find_in_parent_folders()
}

dependency "vpc"{
  config_path = "../vpc"
}


locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.yaml"))
}

inputs = {
  vpc_id = dependency.vpc.outputs.context.vpc_id
  subnets = dependency.vpc.outputs.context.private_subnets
  cluster_name = local.common_vars.locals.eks_cluster_name
  cluster_version = local.common_vars.locals.eks_cluster_version
  autoscaling_group_max_size = local.common_vars.locals.eks_autoscaling_group_max_size
  autoscaling_group_desired_capacity = local.common_vars.locals.eks_autoscaling_group_desired_capacity
  autoscaling_group_min_size = local.common_vars.locals.eks_autoscaling_group_min_size
  worker_group_instance_type = local.common_vars.locals.eks_worker_group_instance_type
  ami_type = local.common_vars.locals.eks_worker_ami_type
  tags = local.common_vars.locals.tags
}
