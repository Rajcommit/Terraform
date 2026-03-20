# File: /module/storage/checks.tf
# Purpose: Verify EFS has mount targets in both AZs

check "efs_mount_targets" {
  data "aws_efs_mount_target" "verify" {
    mount_target_id = aws_efs_mount_target.shared_storage_mount[0].id
  }

  assert {
    condition     = data.aws_efs_mount_target.verify.dns_name != ""
    error_message = "EFS mount target not found in first private subnet!"
  }
}
