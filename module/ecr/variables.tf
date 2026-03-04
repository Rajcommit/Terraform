variable "project_name" {
  description = "Project name"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "node-app"
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}