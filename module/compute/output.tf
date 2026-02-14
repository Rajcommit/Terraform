output "instance_name" {
  value = aws_instance.miniserver[*].tags.Name
}

output "ami_id" {
  value = data.aws_ami.my_ami.id
}

output "instance_ids" {
  value = aws_instance.miniserver[*].id
}

output "instance_ips" {
  value = {
    public_ips  = aws_instance.miniserver[*].public_ip
    private_ips = aws_instance.miniserver[*].private_ip
  }
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.miniserver_profile.name
}


output "security_group_id" {
  value = aws_security_group.miniserver_sg.id
}


output "user_data" {
  value = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /var/www/html/index.html
              EOF
}