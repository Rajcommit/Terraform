# File: /mnt/s/terraform/modules/module/backup/checks.tf
# Purpose: Verify S3 backup bucket has versioning enabled

check "backup_versioning" {
  data "aws_s3_bucket_versioning" "verify" {
    bucket = aws_s3_bucket.backup_bucket.id
  }

  assert {
    condition     = data.aws_s3_bucket_versioning.verify.status == "Enabled"
    error_message = "S3 backup bucket versioning is NOT enabled! Backups are at risk."
  }
}