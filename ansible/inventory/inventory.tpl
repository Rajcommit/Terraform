[master]
localhost ansible_connection=local

[workers]
%{ for ip in worker_ips ~}
${ip} ansible_user=ec2-user ansible_ssh_private_key_file=${ssh_key_path}
%{ endfor ~}

[all:vars]
ansible_python_interpreter=/usr/bin/python3