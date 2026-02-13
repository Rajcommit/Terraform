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
  instance_count        = 2
  subnet_ids            = module.network.private_subnet_ids
  alb_security_group_id = module.loadbalancer.alb_security_group_id
  vpc_id                = module.network.vpc_id

}

