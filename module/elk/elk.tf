data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["al2023-ami-*-x86_64"]
    }
}

resource "aws_security_group" "elk_sg" {
      name = "${var.project_name}-elk-sg"
      description = "Security group for elk stack opening specific security group"
      vpc_id = var.vpc_id


      ingress { 
        description = "Opening Kibana from VPC"
        from_port = 5601
        to_port = 5601
        protocol = "tcp"
        cidr_blocks = [var.vpc_cidr]
      }

      ingress {
        description = "Opening Elasticsearch from VPC"
        from_port = 9200
        to_port = 9200
        protocol = "tcp"
        cidr_blocks = [var.vpc_cidr]
      }

      egress {
         from_port   = 0
         to_port     = 0
         protocol    = "-1"
         cidr_blocks = ["0.0.0.0/0"]
  }
   
   tags = merge(var.common_tags, {
    Name = "${var.project_name}-elk-sg"
  })
}


resource "aws_instance" "elk" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.elk_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.elk_profile.name
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    # Create swap BEFORE Docker starts - ELK needs it
    if [ ! -f /swapfile ]; then
      dd if=/dev/zero of=/swapfile bs=1M count=2048
      chmod 600 /swapfile
    fi
    mkswap /swapfile
    swapon /swapfile
    grep -q '/swapfile' /etc/fstab || echo '/swapfile swap swap defaults 0 0' >> /etc/fstab
    sysctl -w vm.max_map_count=262144
    echo 'vm.max_map_count=262144' >> /etc/sysctl.conf
  EOF

  root_block_device {
      volume_size = 30
      volume_type = "gp3"
      encrypted = true
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-elk-server"
    Role = "monitoring"
  })

}