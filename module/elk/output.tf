output "elk_instance_id" {
    value = aws_instance.elk.id
}

output "elk_private_ip" {
    value = aws_instance.elk.private_ip
}

output "elk_security_group_id" {
    value = aws_security_group.elk_sg.id
}