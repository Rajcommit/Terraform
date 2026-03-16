resource "aws_cloudwatch_log_group" "ec2_system" {
  name              = "/miniserver/system"
  retention_in_days = 30

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-system-logs"
  })
}

resource "aws_cloudwatch_log_group" "ec2_docker" {
  name              = "/miniserver/docker"
  retention_in_days = 30

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-docker-logs"
  })
}
