# Terraform EC2 Instance Setup

## What
This Terraform configuration creates an EC2 instance in AWS with proper VPC and subnet configuration.

## Why
- **VPC Configuration**: AWS requires explicit network configuration when no default VPC exists
- **Subnet Specification**: EC2 instances must be placed in a specific subnet within a VPC
- **Error Prevention**: Avoids "No default VPC" errors during instance creation

## How

### 1. Provider Configuration
```hcl
provider "aws" {
     region = "ap-south-1"
}
```
- **What**: Configures AWS provider
- **Why**: Tells Terraform which AWS region to use
- **How**: Sets region to Mumbai (ap-south-1)

### 2. VPC Data Source
```hcl
data "aws_vpc" "default" {
     default = true
}
```
- **What**: Finds the default VPC in your AWS account
- **Why**: EC2 instances need a VPC (Virtual Private Cloud) to run in
- **How**: Searches for VPC marked as "default"

### 3. Subnets Data Source
```hcl
data "aws_subnets" "default" {
     filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
     }
}
```
- **What**: Finds all subnets within the default VPC
- **Why**: EC2 instances must be placed in a specific subnet
- **How**: Filters subnets by VPC ID from step 2

### 4. EC2 Instance Resource
```hcl
resource "aws_instance" "myec2" {
     ami = "ami-00d2efe5bc0683614"
     instance_type = "t2.micro"
     subnet_id = data.aws_subnets.default.ids[0]
     tags = {
         Name = "MyFirstEC2Instance"
     }
}
```
- **What**: Creates an EC2 instance
- **Why**: Main resource we want to deploy
- **How**: 
  - Uses Ubuntu AMI
  - t2.micro (free tier eligible)
  - Places in first available subnet
  - Tags for identification

## Commands
```bash
terraform init    # Initialize Terraform
terraform plan    # Preview changes
terraform apply   # Create resources
terraform destroy # Remove resources
```

## Error Resolution
The original error "No default VPC for this user" occurred because:
- AWS account had no default VPC
- Terraform couldn't automatically determine where to place the EC2 instance
- Solution: Explicitly specify VPC and subnet using data sources
