# File: /mnt/s/terraform/modules/module/backup/iam.tf
# Purpose: IAM policy for EC2 instances to access S3 backup bucket

data "aws_iam_policy_document" "s3_backup_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]

    resources = [
      aws_s3_bucket.backup_bucket.arn,
      "${aws_s3_bucket.backup_bucket.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketVersioning",
      "s3:GetBucketLifecycleConfiguration"
    ]
    resources = [
      aws_s3_bucket.backup_bucket.arn
    ]
  }
}

resource "aws_iam_policy" "s3_backup_access" {
  name   = "${var.project_name}-s3-backup-access-policy"
  policy = data.aws_iam_policy_document.s3_backup_access.json
  tags = merge(
    var.common_tags,
    var.backup_tags,
    {
      Name = "${var.project_name}-s3-backup-access-policy"
    }
  )
}

##
