locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "HomeNas"
    Owner       = "Raj"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())
  }
}




#Security Group for ALB is passed from network module
resource "aws_lb" "application_load_balancer" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group]
  subnets            = var.public_subnet_ids

  # ingress {
  #   description = "Allow HTTP traffic from ALB"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = var.alb_ingress_cidr_blocks
  # }

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]

  #   description = "Allow all outbound traffic"
  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-alb-sg"
    }
  )
}



#Target Group for ALB
resource "aws_lb_target_group" "app_target_group" {
  name     = "${var.project_name}-target-group"
  port     = var.target_group_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    enabled             = true
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    port                = "traffic-port"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-alb-target-group"
    }
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-listener"
    }
  )
}
