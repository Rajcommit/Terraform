variable "project_name" {
  description = "value to be used as prefix for all resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to be used for the launch template"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type to be used for the launch template"
  type        = string
  default     = "t3.micro"
}

variable "instance_profile_name" {
  description = "Name of the IAM instance profile to be used for the launch template"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group to be associated with the launch template"
  type        = string
}

variable "user_data" {
  description = "User data script to be executed on instance launch"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to be used for the autoscaling group"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the target group to be associated with the autoscaling group"
  type        = string
}


