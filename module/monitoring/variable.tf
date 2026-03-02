variable "project_name" {
  description = "value to be used as prefix for all resources"
    type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

##Creating alarm email variable for monitoring module, it wil be used to send monitoring alarms to the specified email address.
variable "alarm_email" {
  description = "Email address to send monitoring alarms"
  type        = string
  default = "raj.vbeond@gmail.com"
}


## We need asg_name to monitor the ASG and trigger alarms based on its metrics.
variable "asg_name" {
    description = "Name of the Auto Scaling Group to monitor"
    type        = string
}


variable "alb_arn_suffix" {
  description = "ALB ARN suffix for metrics"
  type        = string
}


variable "target_group_arn_suffix" {
  description = "Target Group ARN suffix"
  type        = string
}


variable "cpu_threshold" {
    description = "CPU utilization threshold for triggering alarms"
    type        = number
    default     = 80
}

variable "memory_threshold" {
    description = "Memory utilization threshold for triggering alarms"
    type        = number
    default     = 80
}

variable "disk_threshold" {
    description = "Disk utilization threshold for triggering alarms"
    type        = number
    default     = 80
}
variable "redis_cluster_id" {
  description = "Redis cluster identifier"
  type        = string
}


variable "db_instance_id" {
  description = "RDS instance identifier"
  type        = string
}


variable "redis_threshold" {
  description = "Redis memory usage threshold for triggering alarms"
  type        = number
  default     = 80
}