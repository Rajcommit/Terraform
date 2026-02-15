locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "HomeNas"
    Owner       = "Raj"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())
  }
}



resource "aws_security_group" "rds" {
    name = "${var.project_name}-rds-sg"
    description = "Security group for RDS MYSQL"
    vpc_id = var.vpc_id

    ingress {
        description = "MYSQL from VPC"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = [var.vpc_cidr]
    }

    egress {
        description = "Allowed traffic from internet"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-db-sg"
    }
    )
}