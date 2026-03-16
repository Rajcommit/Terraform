resource "aws_iam_role" "elk_role" {
  name = "${var.project_name}-elk-role"

  assume_role_policy = jsonencode({
       Version = "2012-10-17"
       Statement = [{
         Action = "sts:AssumeRole"
         Effect = "Allow"
         Principal = { Service = "ec2.amazonaws.com"}
       }]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy" "elk_cloudwatch_read" {
  name = "${var.project_name}-elk-cw-read"
  role = aws_iam_role.elk_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:GetLogEvents",
        "logs:FilterLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "arn:aws:logs:*:*:log-group:/miniserver/*"
    }]
  })
}

resource "aws_iam_instance_profile" "elk_profile" {
    name = "${var.project_name}-elk-profile"
    role = aws_iam_role.elk_role.name
  
}