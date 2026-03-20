# File: /module/elk/checks.tf
# Purpose: Verify ELK instance is running

check "elk_running" {
  assert {
    condition     = aws_instance.elk.instance_state == "running"
    error_message = "ELK instance is NOT running! State: ${aws_instance.elk.instance_state}"
  }
}
