provider "aws" {
     region = "ap-south-1"
}

data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["3-tier application -vpc"]
  }
}

# Find public subnets in the VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

# SSH Key Pair
resource "aws_key_pair" "mykey" {
  key_name   = "myec2-key"
  public_key = file("~/.ssh/myec2-key.pub")
}

# Security Group
resource "aws_security_group" "mysg" {
  name_prefix = "myec2-sg"
  vpc_id      = data.aws_vpc.existing.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "myec2-security-group"
  }
}

# EC2 Instance
resource "aws_instance" "myec2" {
  ami                         = "ami-07b580c9db4dd9219"
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.mykey.key_name
  subnet_id                   = data.aws_subnets.public.ids[0]  # First public subnet
  vpc_security_group_ids      = [aws_security_group.mysg.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "ec2-instance"
  }
}


resource "aws_instance" "myec2" {
     ami                    = "ami-00d2efe5bc0683614"
     instance_type          = "t2.micro"
     subnet_id              = data.aws_subnets.default.ids[0]
     vpc_security_group_ids = [aws_security_group.web_sg.id]
     
     tags = {
         Name = "MyFirstEC2Instance"
     }
}

##Outputs
output "instance_id" {
     description = "The ID of the EC2 instance"
     value       = aws_instance.myec2.id
}

output "ssh_command" {
     description = "SSH command to connect to the EC2 instance"
     value       = "ssh -i ~/.ssh/myec2-key.pem ec2-user@${aws_instance.myec2.public_ip}"
}