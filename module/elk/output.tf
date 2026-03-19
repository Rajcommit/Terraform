# File: /mnt/s/terraform/modules/module/elk/output.tf
# Purpose: ELK outputs with precondition verification
# Modified: 2026-03-19

output "elk_instance_id" {
    value = aws_instance.elk.id

    precondition {
      condition = startswith(aws_instance.elk.id, "i-")
      error_message = "ELK instance ID invalid: ${aws_instance.elk.id}"
    }
}

output "elk_private_ip" {
    value = aws_instance.elk.private_ip

    precondition {
      condition = can(regex("^10\\.", aws_instance.elk.private_ip))
      error_message = "ELK IP should be in 10.x range (private subnet). Got: ${aws_instance.elk.private_ip}"
    }
}

output "elk_security_group_id" {
    value = aws_security_group.elk_sg.id
}