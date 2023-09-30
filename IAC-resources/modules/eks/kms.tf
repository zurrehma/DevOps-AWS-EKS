resource "aws_kms_key" "eks_cluster_key" {
  description             = "KMS key For EKS Cluster"
  deletion_window_in_days = 7
}
