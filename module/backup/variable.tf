variable "project_name" {
  description = "value to be used as prefix for all resources"
  type        = string

}

variable "environment" {
  description = "The desired environment"
  type        = string

}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
}


variable "backup_tags" {
  description = "Additional tags to apply to backup resources"
  type        = map(string)
  default     = {}
}


variable "glacier_transition_days" {
  description = "Number of days after which to transition backups to Glacier"
  default     = 30
  type        = number
}