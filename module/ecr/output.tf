# File: /mnt/s/terraform/modules/module/ecr/output.tf
# Purpose: Outputs from ECR module

output "repository_url" {
  description = "ECR repository URL for docker push/pull"
  value       = aws_ecr_repository.app_repository.repository_url
}

output "repository_name" {
  description = "ECR repository name"
  value       = aws_ecr_repository.app_repository.name
}

output "repository_arn" {
  description = "ECR repository ARN"
  value       = aws_ecr_repository.app_repository.arn
}
