terraform {
    source = "../../../modules/kubernetes"
}

include {
    path = find_in_parent_folders()
}

dependency "vpc"{
  config_path = "../eks"
}

inputs = {
  vpc_id = dependency.vpc.outputs.context.vpc_id
  subnets = dependency.vpc.outputs.context.private_subnets
  
}