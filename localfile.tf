


resource "local_file" "vpc" {
  content  = <<-EOF
     VPC Configuration
     =========================
     Environment: ${var.environment}
     Region:      ap-south-1
     VPC CIDR: ${var.vpc_cidr}
     Created: ${timestamp()}
     Network Details:
     DNS Support: Enabled
     DNS Hostnames: Enabled
     Default Security Group: Yes
  
     Subnet Information:
     ===========================
     Subnet ID: ${module.network.private_subnet_ids[0]}
     Subnet CIDR: ${cidrsubnet(var.vpc_cidr, 8, 0)}
     Available IPs: ~251

     Tags:
     ===========================
       Name: main-vpc
       Environment: ${var.environment}
       ManagedBy: Terraform
  
     Notes:
     ===========================
       - This VPC is managed by Terraform
       - Do not modify manually via AWS Console
       - Contact DevOps team for changes
    EOF
  filename = "${path.module}/${var.environment}-vpc.txt"
}

resource "local_file" "subnet" {
  count = var.instance_count

  content  = <<-EOF
     Subnet Configuration
     Environment = ${var.environment}
     Subnet ID: ${module.network.private_subnet_ids[0]}
     Subnet CIDR: ${cidrsubnet(var.vpc_cidr, 8, 0)}
     VPC ID: ${module.network.vpc_id}
    EOF
  filename = "${path.module}/${var.environment}-subnet-${count.index + 2}.txt"

}


resource "local_file" "instance" {
  count = var.instance_count

  content  = <<-EOF
     Instance ${count.index + 1}
     Instance Count: ${var.instance_count}
     Instance IDs: ${join(", ", module.compute.instance_ids)}
     AMI ID: ${module.compute.ami_id}
     Instance Type: t3.micro
     Environment = ${var.environment}
     Subnet ID: ${module.network.private_subnet_ids[0]}
     Instance Number: ${count.index + 1}
    EOF
  filename = "${path.module}/${var.environment}-instance-${count.index + 1}.txt"
}



resource "local_file" "deployment_summary" {
  content  = <<-EOF
             Deployment Summary
             ==================
             Environment: ${var.environment}
             Deployed: ${timestamp()}
             Network:::
                VPC ID: ${module.network.vpc_id}
                Subnet ID: ${module.network.private_subnet_ids[0]}
             Compute::
                Instance IDs: ${join(", ", module.compute.instance_ids)}
                AMI ID: ${module.compute.ami_id}
                Instance Count: ${var.instance_count}
                Instance Type: t3.micro
            EOF
  filename = "${path.module}/${var.environment}-deployment-summary.txt"
}
