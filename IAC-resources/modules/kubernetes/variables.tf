#------------------------------------------------------------------------------
# K8S variables
#------------------------------------------------------------------------------

variable "cluster_name" {
  description = "VPC where the cluster and workers will be deployed."
  type        = string
}

# variable "cluster_crt" {
#   type        = string
#   description = "The name of the EKS cluster."
#   default     = ""
# }

# variable "cluster_token" {
#   type        = string
#   description = "The version of the EKS cluster."
# }
variable "cluster_arn" {
  type = string
}
variable "namespace" {
  type        = string
  default     = ""
  description = "Used as the first prefix for all resources. It is used to group all related resources together at the top level and has nothing to do with Kubernetes namespace. An example for a namespace might be `blue` or `alfa`."
}

variable "environment" {
  type    = string
  default = ""
}
