locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "HomeNas"
    Owner       = "Raj"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())
  }
}

locals {
  db_params = ["max_connections", "shared_buffers"]
  db_values = ["100", "256MB"]
  db_settings = zipmap(local.db_params, local.db_values)
}



resource "random_password" "db_password" {
    length = 16
    special = true
    override_special = "!#$%&*()-_=+[]{}<>:?"  # No /, @, ", space
}

##Storing credentials in Secret Manager

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.project_name}-db-credentials-v2"
  recovery_window_in_days =  0 ##Immediate Deletion (no 30 days wait)

  lifecycle {
    #If secret name conflicts, CREATE newone first , then delte old
    create_before_destroy = true
  }
  tags = merge(
    local.common_tags,
    {
       Name = "${var.project_name}-db-credentials"
       Purpose = "Application data"
    }
  )
}


##Putting the pass in the safe

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
    engine = "mysql"
    host = aws_db_instance.mysql.endpoint
    port = 3306
    dbname = "appdb"
  })
}

##RDS definiton
resource "aws_db_instance" "mysql" {
    identifier = "${var.project_name}"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t3.micro"
    allocated_storage = 20
    storage_type = "gp3"
    parameter_group_name = aws_db_parameter_group.mysql.name
    db_subnet_group_name = aws_db_subnet_group.main.name
    skip_final_snapshot = true
    vpc_security_group_ids = [aws_security_group.rds.id]


    db_name = "appdb"
    username = var.db_username
    password = random_password.db_password.result

    tags = merge( local.common_tags,
    {
           Name = "${var.project_name}-mysql-rds"
    }
)
}


##Custom Parameter Group 

resource "aws_db_parameter_group" "mysql" {
   name = "${var.project_name}-mysql-params"
   family = "mysql8.0"

  ##Adding zipmap locals HERE 
  #Dynamic block goes here 
  dynamic "parameter" {
  for_each = local.db_settings
  content {
    name = parameter.key
    value = parameter.value

     }
  }
   
  #  parameter {
  #    name = "max_connections"
  #    value = "50"
  #  }

   tags = merge(
      local.common_tags,
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


##ElasticCache Redis Subnet Group
resource "aws_elasticache_subnet_group" "redis" {
  name  = "${var.project_name}-redis-subnet"
  subnet_ids = var.private_subnet_ids

  tags = merge(
    local.common_tags,{
         Name = "${var.project_name}-redis-subnet "
    }
  )
}

##Redis Security Group
resource "aws_security_group" "redis" {
   name = "${var.project_name}-redis-sg"
   description = "Security grourp for Redis"
   vpc_id  = var.vpc_id



  ingress { 
     description  = "Redis port from VPC"
     from_port = 6379
     to_port = 6379
     protocol = "tcp"
     cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-redis-sg"
    }
  )
}

##Elasticcache Redis Center

resource "aws_elasticache_cluster" "redis" {
  cluster_id = "${var.project_name}-redis"
  engine = "redis"
  node_type = "cache.t3.micro"
  num_cache_nodes = 1
  parameter_group_name = "default.redis7"
  port = 6379
  subnet_group_name = aws_elasticache_subnet_group.redis.name
  security_group_ids = [aws_security_group.redis.id]


  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-continue to redis-cache"
    }
  )

}

