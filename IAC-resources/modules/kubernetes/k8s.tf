# data "aws_eks_cluster" "cluster" {
#   name = var.cluster_arn
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = var.cluster_name
# }
# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
# }
# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.cluster.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#     token                  = data.aws_eks_cluster_auth.cluster.token
#   }
# }

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

data "kubernetes_config_map" "existing_aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}

# Merge the new IAM users with the existing ConfigMap data
resource "kubernetes_config_map" "updated_aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = merge(
    jsondecode(data.kubernetes_config_map.existing_aws_auth.data["mapRoles"]),
    jsondecode(data.kubernetes_config_map.existing_aws_auth.data["mapUsers"]),
    {
      mapUsers = flatten([
        [
          for user in var.aws-users :
          {
            userarn  = user.arn
            username = user.name
            groups   = user.groups
          }
        ],
      ]),
    }
  )
}

#   data = {
#     mapRoles = jsonencode(local.combined_data.mapRoles),
#     mapUsers = jsonencode(flatten([
#       local.combined_data.mapUsers,
#       [
#         for user in var.aws-users :
#         {
#           userarn  = user.arn
#           username = user.name
#           groups   = user.groups
#         }
#       ]
#     ])),
#   }
# }


