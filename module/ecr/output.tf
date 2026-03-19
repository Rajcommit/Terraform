# File: /mnt/s/terraform/modules/module/ecr/output.tf
# Purpose: ECR outputs with precondition verification
# Modified: 2026-03-19

output "repository_url" {
  description = "ECR repository URL for docker push/pull"
  value       = aws_ecr_repository.app_repository.repository_url

  precondition {
    condition = can(regex(".*\\.dkr\\.ecr\\..*\\.amazonaws\\.com/.*", aws_ecr_repository.app_repository.repository_url))
    error_message = "ECR URL doesn't match expected pattern: ${aws_ecr_repository.app_repository.repository_url}"
  }
}

output "repository_name" {
  description = "ECR repository name"
  value       = aws_ecr_repository.app_repository.name
}

output "repository_arn" {
  description = "ECR repository ARN"
  value       = aws_ecr_repository.app_repository.arn
}
