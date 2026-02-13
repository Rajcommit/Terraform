output "alb_security_group_id" {
  description = "The ID of the security group for the Application Load Balancer"
  value = aws_security_group.alb_sg.id
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.application_load_balancer.arn
}


output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.application_load_balancer.dns_name
}

output "alb_zone_id" {
  description = "The zone ID of the Application Load Balancer"
  value       = aws_lb.application_load_balancer.zone_id
}


output "target_group_arn" {
  description = "The ARN of the target group for the Application Load Balancer"
  value       = aws_lb_target_group.app_target_group.arn
}

output "target_group_name" {
  description = "The name of the target group for the Application Load Balancer"
  value       = aws_lb_target_group.app_target_group.name
}

