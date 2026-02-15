locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "HomeNas"
    Owner       = "Raj"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())
  }
}


##RDS definiton
resource "aws_db_instance" "mysql" {
    identifier = "${var.project_name}-rds"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t3.micro"
    allocated_storage = 20
    storage_type = "gp3"

    db_name = "appdb"
    username = var.db_username
    password = var.db_password
}


##Custom Parameter Group 

resource "aws_db_parameter_group" "mysql" {
   name = "${var.project_name}-mysql-parms"
   family = "mysql8.0"
   
   parameter {
     name = "max_connetions"
     value = "50"
   }

   tags = merge(
      logs.common_tags,
      {
         Name = "${var.project_name}-mysql-params"
      }
   )
}


##RDS Subnet Group
resource "aws_db_subnet_group" "main" {
    name = "${var.project_name}-db-subnet"
    subnet_ids = var.private_subnet_ids 

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project_name}-db-subnet"
        }
    )
}

