variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "instance_count" {
  type        = number
  description = "No of instance to be created"
  default     = 3
  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}

variable "subnet_ids" {
  description = "The subnet ID where instances will be launched"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where instances will be launched"
  type        = string
}

variable "alb_security_group_id" {
  description = "The ID of the security group for the Application Load Balancer"
  type        = string
}