# Purpose: Outputs from storage module
output "efs_id" {
  value = aws_efs_file_system.shared_storage.id
  description = "The ID of the EFS file system"
}

output "efs_dns_name" {
  value = aws_efs_file_system.shared_storage.dns_name
  description = "The DNS name of the EFS file system for mounting"
}

output "efs_mount_target_ids" {
  value = aws_efs_mount_target.shared_storage_mount[*].id
  description = "List of EFS mount target IDs for each AZ"
}

output "efs_arn" {
  description = "EFS ARN"
  value       = aws_efs_file_system.shared_storage.arn
}