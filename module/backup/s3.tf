# File: /mn/s/terraform/modules/module/backup/s3.tf

#Random id generator for unique bucket name
resource "random_id" "bucket_id" {
  byte_length = 4
}


resource "aws_s3_bucket" "backup_bucket" {
  bucket = "${var.project_name}-backup-bucket-${random_id.bucket_id.hex}"
  force_destroy = true

  lifecycle {
    prevent_destroy = false # CHANGED: Allow destroy for testing
  }

  tags = merge(
    var.common_tags,
    var.backup_tags,
    {
      Name = "${var.project_name}-backup-bucket"
    }
  )
}

resource "aws_s3_bucket_versioning" "backup_bucket" {
  bucket = aws_s3_bucket.backup_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backup_bucket" {
  bucket = aws_s3_bucket.backup_bucket.id
  rule {
    id     = "archive-old-backups"
    status = "Enabled"

    transition {
      days          = var.glacier_transition_days
      storage_class = "GLACIER"
    }
    expiration {
      days = var.backup_retention_days
    }
  }
}

resource "aws_s3_bucket_public_access_block" "backup_bucket" {
  bucket = aws_s3_bucket.backup_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_server_side_encryption_configuration" "backup_bucket" {
  bucket = aws_s3_bucket.backup_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
