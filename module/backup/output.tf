# File: /mnt/s/terraform/modules/module/backup/output.tf
# Purpose: Backup outputs with precondition verification
# Modified: 2026-03-19

output "s3_bucket_id" {
  value = aws_s3_bucket.backup_bucket.id # Changed from .backup to .backup_bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.backup_bucket.arn 

  precondition {
    condition     = startswith(aws_s3_bucket.backup_bucket.arn, "arn:aws:s3:::")
    error_message = "S3 bucket ARN is malformed: ${aws_s3_bucket.backup_bucket.arn}"
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.backup_bucket.bucket 
}

output "backup_policy_arn" {
  value = aws_iam_policy.s3_backup_access.arn
}
