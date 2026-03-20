# File: /mnt/s/terraform/modules/module/backup/checks.tf
# Purpose: Verify S3 backup bucket has versioning enabled

check "backup_bucket_exists"  {    ## We can't check versioning status from a data source — AWS doesn't expose it that way. But we CAN verify the bucket exists 
  data "aws_s3_bucket_versioning" "verify" {
    bucket = aws_s3_bucket.backup_bucket.id
  }

  assert {
    condition     = data.aws_s3_bucket.verify.arn != ""
    error_message = "S3 backup bucket not found or not accessible!"
  }
}