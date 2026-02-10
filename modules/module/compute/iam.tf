# IAM Role for EC2 instances
resource "aws_iam_role" "miniserver_role" {
  name = "${var.environment}-miniserver-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-miniserver-role"
    }
  )
}

# Attach AWS managed policy - SSM (for Session Manager)
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.miniserver_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach AWS managed policy - CloudWatch (for logs and metrics)
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.miniserver_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Instance Profile (connects role to EC2)
resource "aws_iam_instance_profile" "miniserver_profile" {
  name = "${var.environment}-miniserver-profile"
  role = aws_iam_role.miniserver_role.name

  tags = local.common_tags
}

# resource "aws_iam_user" "roxy_user" {
#      count = var.instance_count
#    name = "roxy-user.${count.index}"
#    path = "/system/"

#   tags = local.common_tags

# }


# output "iam_name" { 
#     value = aws_iam_user.roxy_user[*].name
# }

# output "iam_arn" { 
#     value = aws_iam_user.roxy_user[*].arn
#     }