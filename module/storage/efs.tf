locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "HomeNas"
    Owner       = "Raj"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())
  }
}



# Purpose: Shared file system for Docker configs
# Related: compute module (mounts this), main.tf (calls this)

resource "aws_efs_file_system" "shared_storage" {
  creation_token = "${var.project_name}-efs"
  encrypted      = true
  
  tags = merge(
    local.common_tags,
    {
       Name = "${var.project_name}-db-credentials"
       Purpose = "Docker configs and shared data"
    }
  )
}

##Mount targets for EFS in each AZ (one per AZ for high availability)
resource "aws_efs_mount_target" "shared_storage_mount" {
    count          = length(var.private_subnet_ids)
    file_system_id = aws_efs_file_system.shared_storage.id
    subnet_id      = var.subnet_ids[count.index]

}