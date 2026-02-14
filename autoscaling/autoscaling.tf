resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-LT"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
        name = var.instance_profile_name
    }

  vpc_security_group_ids = [var.security_group_id]
  user_data= base64encode(var.user_data)

  tag_specifications {
     resource_type = "instance"
     tags = { 
         Name = "${var.project_name}-asg-instance"
    }
  }
}


resource "qws_autoscaling_group" "app" {
    name = "${var.project_name}-asg"
    vpc_zone_identifier = var.subnet_ids
    target_group_args = [var.target_group_arn]

    min_size = 2
    max_size = 4
    desired_capacity = 2

    health_check_type = "ELB"
    health_check_grace_period = 300
    launch_template {
        id = aws_launch_template.app.id
        version = "$Latest"
    }
}