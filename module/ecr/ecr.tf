# Purpose: Container registry for Docker images

resource "aws_ecr_repository" "app_repository" {
    name                 = "${var.project_name}-${var.app_name}-ecr-repository"
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
      scan_on_push = true    # Moe: "Check for bad stuff automatically"
    }
    tags = merge(
        var.common_tags,
        {
        Name = "${var.project_name}-${var.app_name}-ecr-repository"
        Purpose = "Container registry for Docker images"
        }
    )
}

##Lifecycle policy to keep only the 10 most recent images
resource "aws_ecr_lifecycle_policy" "app_lifecycle_policy" {
     repository = aws_ecr_repository.app_repository.name
 
 
     policy  =  jsonencode({
 
      "rules": [
        {
          "rulePriority": 1,     
            "description": "Keep only the 10 most recent images",
            "selection": {
              "tagStatus": "any",
              "countType": "imageCountMoreThan",
              "countNumber": 10 
            },
            "action": {
              "type": "expire"
            }
           }]
         })
      }