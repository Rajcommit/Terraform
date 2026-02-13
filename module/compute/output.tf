output "instance_name" {
  value = aws_instance.miniserver[*].tags.Name
}

output "ami_id" {
  value = data.aws_ami.my_ami.id
}

output "instance_ids" {
  value = aws_instance.miniserver[*].id
}

output "instance_ips" {
  value = {
    public_ips  = aws_instance.miniserver[*].public_ip
    private_ips = aws_instance.miniserver[*].private_ip
  }
}
