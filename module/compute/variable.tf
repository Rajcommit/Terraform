variable "project_name" {
  description = "value to be used as prefix for all resources"
  type        = string
}

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

variable "efs_dns_name" {
  description = "The DNS name of the EFS file system for mounting"
  type        = string
}



variable "aws_region" {
  description = "The AWS region"
  type        = string
}


variable "ecr_registry"{
  description = "ECR registry ID (account ID)"
  type        = string
}