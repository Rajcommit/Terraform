data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "HomeNas"
    Owner       = "Raj"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())
  }
}



data "aws_ami" "my_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "miniserver" {
  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t3.micro"
  count                  = var.instance_count
  key_name               = "myec2key"
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [aws_security_group.miniserver_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.miniserver_profile.name

  #User Data to install Apache Web Server
  user_data = <<-EOF
              #!/bin/bash
              ##Updating System here
              yum update -y
              ##Installing Apache Web Server
              yum install httpd -y

              #Creataing a simple webpage
              echo "<html><body><h1>Welcome to MiniServer Instance ${count.index + 1} in ${var.environment} Environment</h1></body></html>" > /var/www/html/index.html
              echo "<p>Instance ID: $(ec2-metadata --instance-id | cut -d ' ' -f 2)</p>" >> /var/www/html/index.html

              #starting Apache
              systemctl start httpd
              systemctl enable httpd
              EOF
  ##Enable detailed monitorting
  monitoring = true


  ##Custom root volume
  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = false
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-miniserver-${count.index + 1}"
    }
  )
}

resource "aws_security_group" "miniserver_sg" {
  name        = "miniserver-sg"
  description = "Security group for miniserver instances"
  vpc_id      = var.vpc_id

  ##SSH Acess from anywhere enjoy on rohiniyas server
  #Defining rules as alocal variables
  dynamic "ingress" {
    for_each = [
      { port = 22, description = "SSH Access" },
      { port = 80, description = "HTTP Access" },
      { port = 443, description = "HTTPS Access" }
    ]
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = ingress.value.description
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-miniserver-sg"
    }
  )

}

