terraform {
  cloud {
    organization = "RajBuild"
    workspaces {
      name = "Terraform_cli"
    }

  }

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
  retry_mode = "adaptive"
}

# Common tags applied to all resources across all modules
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "MiniServer"
    Owner       = "Raj"
  }
}

module "network" {
  source       = "./module/network"
  environment  = var.environment
  project_name = "miniserver"
}



module "loadbalancer" {
  source            = "./module/loadbalancer"
  environment       = var.environment
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  project_name      = "miniserver"
}


module "compute" {
  source                = "./module/compute"
  project_name          = "miniserver"
  environment           = var.environment
  instance_count        = 1
  efs_dns_name          = module.storage.efs_dns_name
  subnet_ids            = module.network.private_subnet_ids
  alb_security_group_id = module.loadbalancer.alb_security_group_id
  vpc_id                = module.network.vpc_id
  aws_region            = "ap-south-1"
  ecr_registry          = module.ecr.repository_url
  s3_bucket_name        = module.backup.s3_bucket_name
  backup_policy_arn     = module.backup.backup_policy_arn
}



module "autoscalling" {
  source                = "./module/autoscaling"
  project_name          = "miniserver"
  environment           = var.environment
  ami_id                = module.compute.ami_id
  instance_type         = "t3.micro"
  instance_profile_name = module.compute.instance_profile_name
  security_group_id     = module.compute.security_group_id
  user_data             = module.compute.user_data
  subnet_ids            = module.network.private_subnet_ids
  target_group_arn      = module.loadbalancer.target_group_arn

  # ##  Adding the lines

  # min_size  = 1
  # max_size  = 2
  # desired_capacity = 2
}


module "database" {
  source             = "./module/database"
  project_name       = "miniserver-rds"
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  vpc_cidr           = module.network.vpc_cidr
  private_subnet_ids = module.network.private_subnet_ids
}


module "monitoring" {
  source                  = "./module/monitoring"
  project_name            = "miniserver"
  environment             = var.environment
  alarm_email             = "raj.vbeyond@gmail.com"
  asg_name                = module.autoscalling.asg_name
  alb_arn_suffix          = module.loadbalancer.alb_arn_suffix
  target_group_arn_suffix = module.loadbalancer.target_group_arn_suffix
  redis_cluster_id        = module.database.redis_cluster_id
  db_instance_id          = module.database.db_instance_id
}


module "storage" {
  source = "./module/storage"

  project_name       = "miniserver"
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  vpc_cidr           = module.network.vpc_cidr
  private_subnet_ids = module.network.private_subnet_ids
  common_tags        = local.common_tags
}


module "ecr" {
  source = "./module/ecr"

  project_name = "miniserver"
  app_name     = "node-app"
  common_tags  = local.common_tags
}


module "backup" {
  source = "./module/backup"

  project_name = "miniserver"
  environment  = var.environment
  common_tags  = local.common_tags
  backup_tags = {
    Pourpose = "Automated backups"
    Backup   = "true"
  }
  glacier_transition_days = 30
  backup_retention_days   = 365

}

##Generating Ansible inventory from Terraform output
resource "local_file" "ansible_inventory" {
  content  = templatefile("${path.module}/ansible/inventory/inventory.tpl", {
    worker_ips    = module.compute.instance_private_ips
    ssh_key_path  = "~/.ssh/myec2key.pem"
  })
  filename = "${path.module}/ansible/inventory/hosts.ini"
  
  depends_on = [ module.compute ]
}


module "elk" {
  source = "./module/elk"
  project_name       = "miniserver"
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  vpc_cidr           = module.network.vpc_cidr
  private_subnet_ids = module.network.private_subnet_ids
  key_name           = "myec2key"
  common_tags        = local.common_tags

}


resource "local_file" "ansible_inventory" {
  content  = templatefile("${path.module}/ansible/inventory/inventory.tpl", {
    worker_ips   = module.compute.instance_private_ips
    ssh_key_path = "~/.ssh/myec2key.pem"
    elk_ip       = module.elk.elk_private_ip
  })
  filename = "${path.module}/ansible/inventory/hosts.ini"

  depends_on = [module.compute, module.elk]
}
