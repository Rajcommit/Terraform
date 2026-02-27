variable "environment" {
  description = "The devlopment environment (e.g dev,prod ,stage anything in the world)"
  type        = string
  default     = "prod"
}


variable "vpc_cidr" {
  description = "The CIDR block for VPC"
  type        = string
  default     = "10.2.0.0/16"
}

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 2

  validation {
  condition     = var.instance_count <= 2
  error_message = "🚨 FREE TIER: Max 2 instance (750 hours/month). Current: ${var.instance_count}"
}

}