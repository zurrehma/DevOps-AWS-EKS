

resource "aws_iam_policy" "kms_policy" {
  name        = "${var.namespace}-${var.environment}-kms-policy"
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