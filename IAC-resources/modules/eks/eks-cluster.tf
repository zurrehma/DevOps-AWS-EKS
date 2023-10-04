
module "label" {
  source      = "cloudposse/label/null"
  version     = "0.25.0"
  namespace   = var.namespace
  environment = var.environment
  attributes  = var.attributes
  enabled     = var.enabled
  tags        = var.tags
  stage       = var.stage
  name        = var.name
}

locals {
  tags = merge(module.label.tags, var.tags)
}

# data "aws_eks_cluster" "cluster" {
#   name = module.eks.cluster_id
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks.cluster_id
# }


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"

  cluster_name    = "${var.namespace}-${var.environment}-eks-cluster"
  cluster_version = var.cluster_version
  subnet_ids      = var.subnets
  vpc_id          = var.vpc_id
  iam_role_name   = "${var.namespace}-${var.environment}-role"
  iam_role_use_name_prefix = true
  eks_managed_node_group_defaults = {
    ami_type       = var.ami_type
    instance_types = var.worker_group_instance_type

  }

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  #Enable Control plane Logging 
  cluster_enabled_log_types = ["audit", "api", "authenticator", "controllerManager", "scheduler"]

  #Enable KMS Key Encrption 
  create_kms_key            = false
  cluster_encryption_config = {}

  # attach_cluster_encryption_policy = true

  #Cluster Addon 
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {}
  }

  #Node Group Configuration  
  eks_managed_node_groups = {
    "${var.namespace}-${var.environment}-nodes" = {
      min_size     = var.autoscaling_group_min_size
      max_size     = var.autoscaling_group_max_size
      desired_size = var.autoscaling_group_desired_capacity

      instance_types = var.worker_group_instance_type
      create_iam_role          = true
      iam_role_name            = "${var.namespace}-${var.environment}-nodes-role"
      iam_role_use_name_prefix = true
      iam_role_additional_policies = {
        kms           =  aws_iam_policy.kms_policy.arn ,
        ebs           =  "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
        ssmagent      =  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        cloudwatch    =   "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
        secretmanager =  "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
    }
  
      pre_bootstrap_user_data = <<-EOT
      #!/bin/bash
      cd /tmp
      sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      sudo start amazon-ssm-agent
      EOT
    }
  }
  # aws-auth configmap
  create_aws_auth_configmap = true
  # manage_aws_auth_configmap = true
  # aws_auth_roles = [
  #   {
  #     rolearn  = module.eks.iam_role_arn
  #     # rolearn  =  "arn:aws:iam::806240344948:role/holo-test-nodes-role-20231004035659489900000002"
  #     username = "system:node:{{EC2PrivateDNSName}}"
  #     groups = [
  #       "system:bootstrappers",
  #       "system:nodes",
  #     ]
  #   }
  # ]
  #   aws_auth_users = [
  #   {
  #     userarn  = "arn:aws:iam::806240344948:user/zahid"
  #     username = "zahid"
  #     groups   = ["system:masters"]
  #   }
  # ]
  aws_auth_users = [
    for user in var.aws-users :
    {
      userarn  = user.arn
      username = user.name
      groups   = user.groups
    }
  ]
  tags = local.tags
}

# resource "aws_security_group_rule" "allow_all_ingress" {
#   description       = "Allow incoming traffic from load balancer to Jenkins Controller"
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.eks.node_security_group_id
# }