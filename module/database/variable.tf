variable "project_name" {
    description = "Name of the Database"
    type = string
}


variable "vpc_cidr" {
    description = "VPC CIDR block"
    type        = string
}


variable "environment" {
     description = "Environment (dev/staging/prod)"
     type = string
}

variable "vpc_id" {
    description = "VPC ID from network module"
    type = string
}

variable "private_subnet_ids" {
    description = "Subnet IDs from network module"
    type = list(string)
}

variable "db_username" {
    description = "Database master username"
    type = string
    default = "dbadmin"
    validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]{2,15}$", var.db_username))
    error_message = "Username must start with letter, 3-16 chars, alphanumeric + underscore."
  }
}

# variable "db_password" {
#     description = "Database master password"
#     type = string
#     sensitive = true
#     default     = "ChangeMe123!"
# }

