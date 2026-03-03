##AASG HIGH CPU Alarm
resource "aws_sns_topic" "alarms" {
    name = "${var.project_name}-monitoring-alarms"
}

resource "aws_sns_topic_subscription" "email_subscription" {
    topic_arn = aws_sns_topic.alarms.arn
    protocol  = "email"
    endpoint  = var.alarm_email
}


resource "aws_cloudwatch_metric_alarm" "asg_high_cpu" {
  alarm_name          = "${var.asg_name}-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2 ## Alarm will trigger if CPU utilization is above threshold for 2 consecutive periods (10 minutes)
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 900
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_actions = [aws_sns_topic.alarms.arn]  ## when threshold is high then ,  send alarm to the sns, in square bracket because it takes list of arn, we can add multiple arn if we want to send alarm to multiple sns topic.
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

##ALB Unhealthy Host Alarm
resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
    alarm_name = "${var.project_name}-alb-unhealthy-targets"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 2
    metric_name = "UnhealthyHostCount"
    statistic = "Average"
    namespace = "AWS/ApplicationELB"
    period = 300
    threshold = 1 ## Alarm will trigger if there is at least 1 unhealthy host
    alarm_description   = "Alert when ALB has captured unhealthy targets, we neeed to investigate the issue and fix it to ensure high availability of our application."
    alarm_actions = [aws_sns_topic.alarms.arn]
    dimensions = {
        LoadBalancer = var.alb_arn_suffix
        TargetGroup  = var.target_group_arn_suffix
    }
}


# RDS CPU Monitoring Alarm
resource "aws_cloudwatch_metric_alarm" "rds_high_cpu" {
    alarm_name = "${var.project_name}-rds-high-cpu"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    statistic = "Average"
    evaluation_periods = 2
    metric_name = "CPUUtilization"
    namespace = "AWS/RDS"
    period = 300
    threshold = var.cpu_threshold
    alarm_description   = "Alert when RDS instance CPU utilization is high, this could indicate performance issues that may require scaling or optimization."
    alarm_actions = [aws_sns_topic.alarms.arn]
    dimensions = {
        DBInstanceIdentifier = var.db_instance_id
    }
}

# Redis Memory Monitoring
resource "aws_cloudwatch_metric_alarm" "redis_high_memory" {
  alarm_name          = "${var.project_name}-redis-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = var.redis_threshold
  alarm_description   = "Alert when Redis memory exceeds 80%"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    CacheClusterId = var.redis_cluster_id
  }
}


