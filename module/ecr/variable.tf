# File: /mnt/s/terraform/modules/module/ecr/variable.tf
# Purpose: Input variables for ECR module

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "node-app"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
