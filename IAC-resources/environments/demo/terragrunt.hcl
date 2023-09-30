#------------------------------------------------------------------------------
# Root terragrunt config
#------------------------------------------------------------------------------
locals {
  environment = "prod"
  aws_region = "us-east-1"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket              = "tfstate-holo-${local.environment}"
    key                 = "account/${path_relative_to_include()}/terraform.tfstate"
    region              = "${local.aws_region}"
    encrypt             = true
    dynamodb_table      = "${local.environment}_terraform_locking_table"
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