provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_crt)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_crt)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", var.cluster_name]
    }
  }
}
locals {
  aws_auth_data = yamldecode(var.aws_auth["mapRoles"])
}

output "rolearn_values" {
  value = [for entry in local.aws_auth_data : entry.rolearn]
}
# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = <<-EOT
#       - rolearn: arn:aws:iam::ACCOUNT_ID:role/NodeInstanceRole
#         username: system:node:{{EC2PrivateDNSName}}
#         groups:
#           - system:bootstrappers
#           - system:nodes
#       # Add more role mappings as needed
#     EOT

#     mapUsers = <<-EOT
#       - userarn: arn:aws:iam::ACCOUNT_ID:user/USERNAME
#         username: USERNAME
#         groups:
#           - system:masters
#       # Add more user mappings as needed
#     EOT
#   }
# }

