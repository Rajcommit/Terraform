variable "project_name" {
    description = "Project name for resource naming"
    type = string
}


variable "environment" {
  description = "Environment name"
  type = string
}


variable "vpc_id" {
   description = "VPC ID for security group" 
   type = string 
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EC2 placement"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for ELK"
  type        = string
  default     = "t3.small"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "VPC CIDR for security group ingress"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name for EC2"
  type        = string
}