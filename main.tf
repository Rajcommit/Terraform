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
  region = "ap-south-1"
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
  environment           = var.environment
  instance_count        = 0
  subnet_ids            = module.network.private_subnet_ids
  alb_security_group_id = module.loadbalancer.alb_security_group_id
  vpc_id                = module.network.vpc_id

}



module "autoscalling" {
  source                = "./module/autoscaling"
  project_name          = "miniserver"
  ami_id                = module.compute.ami_id
  instance_type         = "t3.micro"
  instance_profile_name = module.compute.instance_profile_name
  security_group_id     = module.compute.security_group_id
  user_data             = module.compute.user_data
  subnet_ids            = module.network.private_subnet_ids
  target_group_arn      = module.loadbalancer.target_group_arn
}


module "database" {
  source = "./module/database"
  project_name = "miniserver-rds"
  environment = var.environment
  vpc_id = module.network.vpc_id
  vpc_cidr = module.network.vpc_cidr
  private_subnet_ids = module.network.private_subnet_ids
}