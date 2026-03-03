locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "HomeNas"
    Owner       = "Raj"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())
  }
}



# Purpose: Shared file system for Docker configs
# Related: compute module (mounts this), main.tf (calls this)

resource "aws_efs_file_system" "shared_storage" {
  creation_token = "${var.project_name}-efs"
  encrypted      = true
  
  tags = merge(
    local.common_tags,
    {
       Name = "${var.project_name}-efs"
       Purpose = "Docker configs and shared data"
    }
  )
}

##Mount targets for EFS in each AZ (one per AZ for high availability)
resource "aws_efs_mount_target" "shared_storage_mount" {
    count          = length(var.private_subnet_ids)
    file_system_id = aws_efs_file_system.shared_storage.id
    subnet_id      = var.private_subnet_ids[count.index]
    security_groups = [aws_security_group.efs.id]
}

resource "aws_security_group" "efs" {
    name =      "${var.project_name}-efs-sg"
    description = "Security group for EFS mount targets"
    vpc_id = var.vpc_id

    tags = merge(
    local.common_tags,
    {
       Name = "${var.project_name}-efs-sg"
       Purpose = "Docker configs and shared data"
    }
  )
}

resource "aws_security_group_rule" "efs_ingress" {
    type = "ingress"
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr]
    security_group_id = aws_security_group.efs.id
    description = "Allow NFS traffic from ASG instances"
}


resource "aws_security_group_rule" "efs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.efs.id
  description       = "Allow all outbound"
}
