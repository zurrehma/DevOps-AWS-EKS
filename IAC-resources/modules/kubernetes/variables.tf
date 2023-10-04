#------------------------------------------------------------------------------
# K8S variables
#------------------------------------------------------------------------------

# variable "cluster_endpoint" {
#   description = "VPC where the cluster and workers will be deployed."
#   type        = string
# }

# variable "cluster_crt" {
#   type        = string
#   description = "The name of the EKS cluster."
#   default     = ""
# }

# variable "cluster_token" {
#   type        = string
#   description = "The version of the EKS cluster."
# }
variable "cluster_id" {
  type = string
}