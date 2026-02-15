output "dbusername" {
    description = "Database username"
    value       = var.db_username
}

output "dbpassword" {
    description = "Database password"
    value       = var.db_password
    sensitive   = true
}

output "rds_endpoint" {
    description = "RDS MYSQL PORT"
    value = aws_db_instance.mysql.endpoint
}

output "rds_port" {
    description = "RDS Mysql port"
    value = aws_db_instance.mysql.port
}

output "db_username" {
    description = "Database username"
    value = var.db_username
}
