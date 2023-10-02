resource "aws_kms_key" "eks_cluster_key" {
  description             = "KMS key For EKS Cluster"
  deletion_window_in_days = 7
}

resource "aws_iam_policy" "kms_policy" {
  name        = "kms-eks-policy"
  description = "KMS IAM policy created with Terraform"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CreateKMSKey",
            "Effect": "Allow",
            "Action": [
                "kms:CreateKey",
                "kms:ListKeys",
                "kms:CreateGrant",
                "kms:ScheduleKeyDeletion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "UseKMSKey",
            "Effect": "Allow",
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey",
                "kms:GetKeyPolicy",
                "kms:GetKeyRotationStatus",
                "kms:ListResourceTags"
            ],
            "Resource": "*"
        }
    ]
})
}