#------------------------------------------------------------------------------
# Root terragrunt config
#------------------------------------------------------------------------------
locals {
  aws_account       = "test-jenkins"
  // default_yaml_path = find_in_parent_folders("empty.yaml")
  tags = {
    "team"        = "delivery pipeline"
    "service"     = "demo-jenkins-k8s"
    "env"         = "demo"
  }
}
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket              = "tfstate-${local.aws_account}"
    key                 = "account/${path_relative_to_include()}/terraform.tfstate"
    region              = "us-east-1"
    encrypt             = true
    dynamodb_table      = "terraform_locking_table"
    s3_bucket_tags      = local.tags
    dynamodb_table_tags = local.tags
  }
}
# ------------------------------------------------------------------------------
# Global parameters
# These variables apply to all configurations in this subfolder. These are
# automatically merged into the child `terragrunt.hcl` config via the include
# block.
# ------------------------------------------------------------------------------
inputs = merge(
  yamldecode(
    file("account.yaml")
  ),
)
terraform {
  before_hook "before_hook" {
    commands     = ["plan", "apply"]
    execute      = ["terraform", "init"]
  }
}