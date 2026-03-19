data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "HomeNas"
    Owner       = "Raj"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())
  }
}

##Vpc Creation
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge(
    local.common_tags,
    {
      Name     = "${var.project_name}-vpc"
      VCS-Test = "GitOps-Workflow-Test"
    }
  )

  lifecycle {
     postcondition {
       condition = self.enable_dns_support == true
       error_message = "VPC DNS support must be enabled! Instances won't resolve AWS service endpoints without it."
     }
  }
}

##Public subnet creation
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-publicsubnet-${count.index + 1}"
      Type = "Public"
    }
  )
}


##Private subnet creation
resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 10)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-private-subnet-${count.index + 1}"
      Type = "Private"
    }
  )
}

##Internet Gateway Creation
resource "aws_internet_gateway" "maingateway" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-igw"
    }
  )

}

##NAT Gateway Creation
resource "aws_eip" "elastic_ip" {
  count  = var.nat_gateway_enabled ? 1 : 0
  domain = "vpc"
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-nat-eip"
    }
  )
}

##NAT Gateway Creation
resource "aws_nat_gateway" "main" {
  count = var.nat_gateway_enabled ? 1 : 0 
  allocation_id = aws_eip.elastic_ip[count.index].id 
  subnet_id     = aws_subnet.public[0].id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-nat-gateway"
    }
  )

  depends_on = [aws_internet_gateway.maingateway]
}

##Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.maingateway.id
  }
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-public-rt"
    }
  )
}

##Route Table for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[0].id
  }
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-private-rt"
    }
  )
}

##Associating Public Subnet with Route Table
resource "aws_route_table_association" "public_association" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

}


##Associating Private Subnet with Route Table
resource "aws_route_table_association" "private_association" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id

}


# Add NAT Gateway toggle

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway (costs $40.88/month)"
  type        = bool
  default     = true  # Set false to save money
}





# #!/bin/bash
# ##Updating System here
# yum update -y

# ##Install EFS utilities
# yum install -y amazon-efs-utils nfs-utils

# ##Create mount directory
# mkdir -p /mnt/efs

# ##Mount EFS
# mount -t nfs4 -o nfsvers=4.1 ${var.efs_dns_name}:/ /mnt/efs

# ##Add to fstab for auto-mount on reboot
# echo "${var.efs_dns_name}:/ /mnt/efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0" >> /etc/fstab

# ##Create Docker directories on EFS
# mkdir -p /mnt/efs/docker-volumes
# mkdir -p /mnt/efs/docker-configs
# mkdir -p /mnt/efs/app-data

# ##Set permissions
# chmod 755 /mnt/efs/docker-volumes
# chmod 755 /mnt/efs/docker-configs
# chmod 755 /mnt/efs/app-data

# ##Installing Apache Web Server
# yum install httpd -y

# #Creating a simple webpage
# echo "<html><body><h1>Welcome to MiniServer Instance ${count.index + 1} in ${var.environment} Environment</h1></body></html>" > /var/www/html/index.html
# echo "<p>Instance ID: $(ec2-metadata --instance-id | cut -d ' ' -f 2)</p>" >> /var/www/html/index.html
# echo "<p>EFS Mounted: /mnt/efs</p>" >> /var/www/html/index.html

# #starting Apache
# systemctl start httpd
# systemctl enable httpd
