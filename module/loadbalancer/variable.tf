##environment variable
variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}


variable "vpc_id" {
  description = "VPC ID where ALB will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}




##Creating ALB security group
variable "alb_ingress_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

##Create Target Group
variable "target_group_port" {
  description = "The port on which the target group will receive traffic"
  type        = number
  default     = 80
}

##creating the ALB
variable "alb_name" {
  description = "The name of the Application Load Balancer"
  type        = string
  default     = "minicompute-alb"
}

##Create a listener for the ALB
variable "listener_port" {
  description = "The port on which the ALB will listen for incoming traffic"
  type        = number
  default     = 80
}


