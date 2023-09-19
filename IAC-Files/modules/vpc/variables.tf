#------------------------------------------------------------------------------
# VPC variables
#------------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  description = "The region to deploy the resoruces in"
}

variable "skip_region_validation" {
  type        = bool
  description = "Skip region validation for new AWS regions"
  default     = false
}

variable "cidr_b_block" {
  description = "This VPC will always create CIDR blocks in the 10.X.0.0/16 range. This variable is the X in this equation."
  type        = number
  default     = 130
}

variable "vpc_name" {
  type    = string
  default = "eks-vpc"
}

#------------------------------------------------------------------------------
# tf-null-label variables
#------------------------------------------------------------------------------
variable "namespace" {
  type        = string
  default     = ""
  description = "(Mandatory) Used as the first prefix for all resources. It is used to group all related resources together at the top level and has nothing to do with Kubernetes namespace. An example for a namespace might be `blue` or `alfa`."
}

variable "environment" {
  type        = string
  default     = ""
  description = "(Mandatory) Environment. Allowed values: `dev`, `qa`, `sit`, `staging`, `prod`, `dr`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "(Optional) Additional attributes (e.g. `1`)"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "stage" {
  type        = string
  default     = null
  description = "ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = string
  default     = null
  description = <<-EOT
    ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.
    This is the only ID element not also included as a `tag`.
    The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input.
    EOT
}
variable "requester_vpc" {
  type    = string
  # default = "vpc-96da5af2"
}


