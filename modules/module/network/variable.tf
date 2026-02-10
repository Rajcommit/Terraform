variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.2.0.0/16"
}

variable "availability_zone" {
  description = "The AWS availability zone to launch resources in"
  type        = string
  default     = "ap-south-1a"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "FourTierVPC"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = list(string)
  default     = ["10.2.0.0/24", "10.2.1.0/24"]
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = list(string)
  default     = ["10.2.10.0/24", "10.2.11.0/24"]
}

variable "nat_gateway_enabled" {
  description = "Flag to enable or disable NAT Gateway"
  type        = bool
  default     = true
}