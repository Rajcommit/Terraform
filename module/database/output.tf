# output "dbusername" {
#     description = "Database username"
#     value       = var.db_username
# }

# output "dbpassword" {
#     description = "Database password"
#     value       = var.db_password
#     sensitive   = true
# }

output "rds_endpoint" {
    description = "RDS MYSQL PORT"
    value = aws_db_instance.mysql.endpoint

    precondition {
      condition = can(regex(".*\\.rds\\.amazonaws\\.com",aws_db_instance.mysql.endpoint))
      error_message = "RDS endpoint doesn't match expected AWS format: ${aws_db_instance.mysql.endpoint}"
    }
}

output "rds_port" {
    description = "RDS Mysql port"
    value = aws_db_instance.mysql.port
}

output "db_secret_arn" {
    description = "ARN of the database secret_credentials for future refrencing"
    value = aws_secretsmanager_secret.db_credentials.arn
    
    precondition {
        condition = startswith(aws_secretsmanager_secret.db_credentials.arn, "arn:aws:secretsmanager:")
        error_message = "Secret ARN is invalid: ${aws_secretsmanager_secret.db_credentials.arn}"
    }
}


output "redis_endpoint" {
    description = "Redis cache endpoint"
    value = aws_elasticache_cluster.redis.cache_nodes[0].address

    precondition {
      condition = length(aws_elasticache_cluster.redis.cache_nodes) > 0
      error_message = "Redis endpoint is empty — cluster may have failed to provision nodes!"
    }
}

output "redis_port" {
    description = "Redis port"
    value = aws_elasticache_cluster.redis.port
}


output "db_instance_id" {
    description = "RDS instance identifier for future reference"
    value = aws_db_instance.mysql.id
}

output "redis_cluster_id" {
    description = "Redis cluster identifier for future reference"
    value = aws_elasticache_cluster.redis.id
}

#
