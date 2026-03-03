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
}

output "rds_port" {
    description = "RDS Mysql port"
    value = aws_db_instance.mysql.port
}

output "db_secret_arn" {
    description = "ARN of the database secret_credentials for future refrencing"
    value = aws_secretsmanager_secret.db_credentials.arn
}


output "redis_endpoint" {
    description = "Redis cache endpoint"
    value = aws_elasticache_cluster.redis.cache_nodes[0].address
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