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
}

variable "db_password" {
    description = "Database master password"
    type = string
    sensitive = true
    default     = "ChangeMe123!"
}