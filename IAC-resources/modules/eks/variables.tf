#------------------------------------------------------------------------------
# EKS variables
#------------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  description = "The region to deploy the resoruces in"
}

variable "vpc_id" {
  description = "VPC where the cluster and workers will be deployed."
  type        = string
}

variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster."
  default     = ""
}

variable "cluster_version" {
  type        = string
  description = "The version of the EKS cluster."
}

variable "ami_type" {
  type    = string
  default = "AL2_x86_64"
}

variable "subnets" {
  description = "A list of subnets to place the EKS cluster and workers within."
  type        = list(string)
}

variable "worker_group_instance_type" {
  type        = list(string)
  description = "The instance type of the worker group nodes. Must be large enough to support the amount of NICS assigned to pods."
  default     = ["t3.large"]
}

variable "autoscaling_group_min_size" {
  type        = number
  description = "The minimum number of nodes the worker group can scale to."
  default     = 1
}

variable "autoscaling_group_desired_capacity" {
  type        = number
  description = "The desired number of nodes the worker group should attempt to maintain."
  default     = 2
}

variable "autoscaling_group_max_size" {
  type        = number
  description = "The maximum number of nodes the worker group can scale to."
  default     = 3
}


#------------------------------------------------------------------------------
# tf-null-label variables
#------------------------------------------------------------------------------
variable "namespace" {
  type        = string
  default     = ""
  description = "Used as the first prefix for all resources. It is used to group all related resources together at the top level and has nothing to do with Kubernetes namespace. An example for a namespace might be `blue` or `alfa`."
}

variable "environment" {
  type    = string
  default = ""
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
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
# variable "aws-users" {
#   type = object({
#       arn = string
#       name= string
#       group= string
#   })
  
# }