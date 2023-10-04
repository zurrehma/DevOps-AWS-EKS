#------------------------------------------------------------------------------
# K8S variables
#------------------------------------------------------------------------------
variable "cluster_arn" {
  type = string
}
variable "cluster_endpoint" {
  type        = string
}
variable "cluster_crt" {
  type        = string
}
variable "cluster_name" {
  type        = string
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
