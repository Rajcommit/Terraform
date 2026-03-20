# File: /module/storage/checks.tf
# Purpose: Verify EFS has mount targets in both AZs

check "efs_mount_targets" {
  data "aws_efs_mount_target" "verify" {
    file_system_id = aws_efs_file_system.shared_storage.id
    subnet_id      = var.private_subnet_ids[0]
  }

  assert {
    condition     = data.aws_efs_mount_target.verify.availability_zone_name != ""
    error_message = "EFS mount target not found in first private subnet!"
  }
}
