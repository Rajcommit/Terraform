# File: /module/elk/checks.tf
# Purpose: Verify ELK instance is running

check "elk_running" {
  data "aws_instance" "verify_elk" {
    instance_id = aws_instance.elk.id
  }

  assert {
   condition     = data.aws_instance.verify_elk.instance_state == "running"
   error_message = "ELK instance is NOT running! State: ${data.aws_instance.verify_elk.instance_state}"
  }
}