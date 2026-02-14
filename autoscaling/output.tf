output "asg_name" {
    description = "Name of the autoscaling group"
    value = aws_autoscaling_group.app.name
}

output "asg_arn" {
    description = "ARN of the autoscaling group"
    value = aws_autoscaling_group.app.arn
}