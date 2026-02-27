variable "project_name" {
  description = "value to be used as prefix for all resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to be used for the launch template"
  type        = string
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


variable "environment" {
  description = "The desired environment"
  type= string
}

variable "max_size" {
     type = number
     default =2
    validation {
      condition = var.max_size <= 2
      error_message = "🚨 FREE TIER LIMIT: Max 2 EC2 instance (750 hours/month). Current: ${var.max_size}"
    } 
  }


variable "min_size" {
  type = number
  default = 1
}


variable "desired_capacity" {
  type = number
  default = 2
}                                                                                                                                        
                                                                                                                                              
  variable "managed_by" {                                                                                                                     
    description = "Tool managing infrastructure"                                                                                              
    type        = string                                                                                                                      
    default     = "Terraform"                                                                                                                 
  }                                                                                                                                           
                                                                                                                                              
  variable "project_tag" {                                                                                                                    
    description = "Project tag value"                                                                                                         
    type        = string                                                                                                                      
    default     = "HomeNas"                                                                                                                   
  }                                                                                                                                           
                                                                                                                                              
  variable "owner" {                                                                                                                          
    description = "Owner tag value"                                                                                                           
    type        = string                                                                                                                      
    default     = "Raj"                                                                                                                       
  }                            

  

  variable "instance_type" {
    description = "EC2 instance type to be used for the launch template"
    type = string
    default = "t3.micro"

    validation {
      condition = contains(["t2.micro", "t3.micro"], var.instance_type)
      error_message = "🚨 FREE TIER: Only t2.micro or t3.micro allowed. Current: ${var.instance_type}"
    }
  }