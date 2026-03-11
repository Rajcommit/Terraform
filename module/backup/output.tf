# File: /mnt/s/terraform/modules/module/backup/output.tf

output "s3_bucket_id" {
  value = aws_s3_bucket.backup_bucket.id  # Changed from .backup to .backup_bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.backup_bucket.arn  # Changed!
}

output "s3_bucket_name" {
  value = aws_s3_bucket.backup_bucket.bucket  # Changed!
}

output "backup_policy_arn" {
  value = aws_iam_policy.s3_backup_access.arn
}
