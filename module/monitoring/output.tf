output "sns_topic_arn" {
  description = "ARN of SNS topic for alarm notifications"
  value       = aws_sns_topic.alarms.arn
}

output "alarm_names" {
  description = "Names of all CloudWatch alarms"
  value = [
    aws_cloudwatch_metric_alarm.asg_high_cpu.alarm_name,
    aws_cloudwatch_metric_alarm.alb_unhealthy_targets.alarm_name,
    aws_cloudwatch_metric_alarm.rds_high_cpu.alarm_name,
    aws_cloudwatch_metric_alarm.redis_high_memory.alarm_name
  ]
}


output "sns_topic_arn" {
  description = "ARN of SNS topic for alarm notifications"
  value       = aws_sns_topic.alarms.arn
  
}