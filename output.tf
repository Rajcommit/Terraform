output "netowrk_info" {
  value = {
    vpc_id     = module.network.vpc_id
    subnet_ids = module.network.private_subnet_ids
  }
}

output "compute_info" {
  value = {
    instance_ids = module.compute.instance_ids
  }

}

output "image_info" {
  value = {
    ami_id = module.compute.ami_id
  }
}

output "instance_ids" {
  value = module.compute.instance_ids
}

output "ami_id" {
  value = module.compute.ami_id
}

output "vpc_id" {
  value = module.network.vpc_id
}
output "subnet_id" {
  value = module.network.private_subnet_ids
}
output "instance_count" {
  value = var.instance_count
}

output "deployment_details" {
  value = {
    environment    = var.environment
    vpc_id         = module.network.vpc_id
    subnet_id      = module.network.private_subnet_ids
    instance_ids   = module.compute.instance_ids
    ami_id         = module.compute.ami_id
    instance_count = var.instance_count
  }
}

output "deployment_summary_file" {
  value = <<EOF
    Deployment Summary
    ==================
    Environment: ${var.environment}
    Deployed: ${timestamp()}
    Network:::
        VPC ID: ${module.network.vpc_id}
        Subnet ID: ${join(", ", module.network.private_subnet_ids)}
    Compute::
        Instance IDs: ${join(", ", module.compute.instance_ids)}
        AMI ID: ${module.compute.ami_id}
        Instance Count: ${var.instance_count}
        Instance Type: t3.micro
  EOF
}


output "resourcce_overview" {
  value = {
    vpc_id       = module.network.vpc_id
    subnet_id    = module.network.private_subnet_ids
    instance_ids = module.compute.instance_ids
    ami_id       = module.compute.ami_id
  }
}



##Output for github actions
output "worker_ips" {
  value = module.compute.instance_private_ips
}
