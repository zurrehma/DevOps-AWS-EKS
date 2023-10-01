terraform {
    source = "../../../modules/eks"
}

include {
    path = find_in_parent_folders()
}

dependency "vpc"{
  config_path = "../vpc"
}

inputs = {
  vpc_id = dependency.vpc.outputs.context.vpc_id
  subnets = dependency.vpc.outputs.context.private_subnets
  
}