terraform {
  cloud {
    organization = "RAjAbhishek"
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

module "compute" {
  source         = "./module/compute"
  environment    = var.environment
  instance_count = 2
  subnet_ids     = module.network.private_subnet_ids
  vpc_id         = module.network.vpc_id

}

module "loadbalancer" {
  source             = "./module/loadbalancer"
  environment        = var.environment
  alb_security_group = module.network.alb_security_group_id
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  project_name       = "miniserver"
}
