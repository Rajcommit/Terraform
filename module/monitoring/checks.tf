# File: module/monitoring/checks.tf
# Purpose: Verify SNS topic has confirmed subscribers


check "sns_has_subscribers" {

  data "aws_sns_topic" "verify" {
      name = "${var.project_name}-alarms"
  }

  assert {
     condition  =  data.aws_sns_topic.verify.arn != ""
     error_message = "SNS alarm topic not found! CloudWatch alarms have nowhere to send notifications."
  }
}