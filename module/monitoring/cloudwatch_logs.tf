## We will create cloudwatch log group ec2_system with retention 30 days, so below are the resource and its definion

resource "aws_cloudwatch_log_group" "ec2_system" {
    name = "/miniserver/system"
    retention_in_days =30

    tags = merge(var.common_tags, {
        Name = "${var.project_name}-system-logs"
    })
}


resource "aws_cloudwatch_log_group" "ec2_docker" {
    name = "/miniserver/docker"
    retention_in_days = 30
    
    tags = merge(var.common_tags, {
        Name = "${var.project_name}-system-logs"
    })
}
