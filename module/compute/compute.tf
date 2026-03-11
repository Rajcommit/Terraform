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

# Add zipmap for ports
 services = ["ssh", "https"]
 ports = [22, 443]
 service_ports = zipmap(local.services, local.ports)
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

# Cloud-init user data
   user_data = templatefile("${path.module}/scripts/cloud-init.yaml", {
    instance_number = count.index + 1
    environment     = var.environment
    aws_region      = var.aws_region
    efs_dns_name    = var.efs_dns_name
    s3_bucket_name  = var.s3_bucket_name
    ecr_registry    = var.ecr_registry
  })

  monitoring = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true  # Always encrypt!
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-instance-${count.index + 1}"
    }
  )

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.module}/../../../logs
      echo "=== NEW INSTANCE CREATED ===" >> ${path.module}/../../../logs/instances.log
      echo "Instance ID: ${self.id}" >> ${path.module}/../../../logs/instances.log
      echo "Private IP: ${self.private_ip}" >> ${path.module}/../../../logs/instances.log
      echo "AZ: ${self.availability_zone}" >> ${path.module}/../../../logs/instances.log
      echo "Type: ${self.instance_type}" >> ${path.module}/../../../logs/instances.log
      echo "Created: $(date -u +"%Y-%m-%d %H:%M:%S UTC")" >> ${path.module}/../../../logs/instances.log
      echo "Status: RUNNING" >> ${path.module}/../../../logs/instances.log
      echo "---" >> ${path.module}/../../../logs/instances.log
    EOT

    on_failure = continue
  }
}

              #   <<-EOF
              # #!/bin/bash
              # ##Updating System here
              # yum update -y
              # ##Attaching the efs here for persistent storage
              # yum install -y amazon-efs-utils
              # mkdir -p /mnt/efs
              # mount -t nfs4 ${var.efs_dns_name}:/ /mnt/efs
              # ##Installing Apache Web Server

              # ##INSTALLING DOCKER
              # yum install -y docker
              # systemctl start docker
              # systemctl enable docker
              # usermod -aG docker ec2-user

              # ##Login to ECR and pull Docker image
              # aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.ecr_registry}    
              # docker pull ${var.ecr_registry}/miniserver-node-app:latest
              # docker run -d -p 3000:3000 --name miniserver-app ${var.ecr_registry}/miniserver-node-app:latest

              # #Creataing a simple webpage
              # echo "<html><body><h1>Welcome to MiniServer Instance ${count.index + 1} in ${var.environment} Environment</h1></body></html>" > /var/www/html/index.html
              # echo "<p>Instance ID: $(ec2-metadata --instance-id | cut -d ' ' -f 2)</p>" >> /var/www/html/index.html

              # #starting Apache
              # systemctl start httpd
              # systemctl enable httpd


              # ##Backup to S3, no data loss forever
              
              # BACKUP_DIR="/var/backups"
              # S3_BUCKET="${var.s3_bucket_name}"
              # DATE=$(date +%Y-%m-%d-%H-%M-%S)
              # BACKUP_FILE="backup-$DATE.tar.gz"
              # INSTANCE_ID=$(ec2-metadata --instance-id | cut -d ' ' -f 2)
              
              # # Create backup directory
              # mkdir -p $BACKUP_DIR
              
              # # Create backup (add your important directories here)
              # tar -czf $BACKUP_DIR/$BACKUP_FILE \
              #   /var/www/html \
              #   /mnt/efs \
              #   /var/log/httpd 2>/dev/null
              
              # # Upload to S3
              # aws s3 cp $BACKUP_DIR/$BACKUP_FILE s3://$S3_BUCKET/$INSTANCE_ID/ --region ${var.aws_region}
              
              # # Keep only last 7 days locally
              # find $BACKUP_DIR -name "backup-*.tar.gz" -mtime +7 -delete
              
              # echo "$(date): Backup completed - $BACKUP_FILE uploaded to s3://$S3_BUCKET/$INSTANCE_ID/" >> /var/log/backup.log
              # BACKUP_SCRIPT
              
              #               # Make script executable
              #               chmod +x /usr/local/bin/backup.sh
                            
              #               # Add cron job (runs daily at 2 AM)
              #               echo "0 2 * * * /usr/local/bin/backup.sh >> /var/log/backup.log 2>&1" | crontab -
                            
              #               # Run first backup immediately
              #               /usr/local/bin/backup.sh
              #   EOF

resource "aws_security_group" "miniserver_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for miniserver instances"
  vpc_id      = var.vpc_id

  #Dynamic rules drom zipmap (SSH +HTTPS)
  dynamic "ingress" {
    for_each = local.service_ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "${ingress.key} Access"
    }
  }
  # # SSH - open to all
  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = "SSH Access"
  # }

  # HTTP - only from ALB
  ingress {
    from_port       = 3000
    to_port         = 3000  ## changed for docker port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
    description     = "HTTP Access from ALB"
  }

  # # HTTPS - open to all
  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = "HTTPS Access"
  # }
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
      Name = "${var.project_name}-miniserver-sg"
    }
  )
}
