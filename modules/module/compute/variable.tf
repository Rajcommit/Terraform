variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "instance_count" {
  type        = number
  description = "No of instance to be created"
  default     = 3
}

variable "subnet_ids" {
  description = "The subnet ID where instances will be launched"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where instances will be launched"
  type        = string
}