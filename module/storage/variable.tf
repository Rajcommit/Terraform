variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
}


variable "private_subnet_ids" {
  description = "List of private subnet IDs for EFS mount targets"
  type        = list(string)
}


variable "subnet_ids" {
  description = "List of subnet IDs to be used for the EFS mount targets"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where EFS will be created"
  type        = string
}


variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}