#terraform {
#  required_version = ">= 1.0"
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = "~> 5.0"
#    }
#  }
#}
#
#provider "aws" {
#  region = "us-east-1"
#}
#
## Example resource - uncomment and modify as needed
## resource "aws_s3_bucket" "example" {
##   bucket = "my-terraform-bucket-${random_string.bucket_suffix.result}"
## }
#
## resource "random_string" "bucket_suffix" {
##   length  = 8
##   special = false
##   upper   = false
## }
#