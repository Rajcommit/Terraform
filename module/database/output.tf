output "dbusername" {
    value = aws_db_instance.mysql.username
}

output "dbpassword" {
  value = aws_db_instance.mysql.password
}