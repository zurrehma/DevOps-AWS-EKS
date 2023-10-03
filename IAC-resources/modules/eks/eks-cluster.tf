
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

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.28.0"

  cluster_name    = "${var.namespace}-${var.environment}-eks-cluster"
  cluster_version = var.cluster_version
  subnet_ids      = var.subnets
  vpc_id          = var.vpc_id
  iam_role_name   = "${var.namespace}-${var.environment}-role"
  eks_managed_node_group_defaults = {
    ami_type       = var.ami_type
    instance_types = var.worker_group_instance_type

  }

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  #Enable Control plane Logging 
  cluster_enabled_log_types = ["audit", "api", "authenticator", "controllerManager", "scheduler"]

  #Enable KMS Key Encrption 
  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks_cluster_key.arn
    resources        = ["secrets"]
  }]
  attach_cluster_encryption_policy = true

  #Cluster Addon 
  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
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
      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
        "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
        "arn:aws:iam::806240344948:policy/kms-eks-policy"
      ]
      pre_bootstrap_user_data = <<-EOT
      #!/bin/bash
      cd /tmp
      sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      sudo start amazon-ssm-agent
      EOT
    }
  }
  # aws-auth configmap
  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = module.eks.eks_managed_node_group
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
      ]
    }
  ]
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

resource "aws_security_group_rule" "allow_all_ingress" {
  description       = "Allow incoming traffic from load balancer to Jenkins Controller"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.node_security_group_id
}

resource "aws_security_group_rule" "allow_all_egress" {
  description       = "Allow all outbound traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.node_security_group_id
}

# resource "aws_iam_policy_attachment" "eks_policy_attachment" {
#   name       = "${var.namespace}-${var.environment}-policy-attachment"
#   policy_arn = aws_iam_policy.kms_policy.arn
#   roles      = [module.eks.eks_managed_node_groups.iam_role_arn]
# }
