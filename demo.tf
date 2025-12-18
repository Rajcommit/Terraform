provider "aws" {
     region = "ap-south-1"
}

data "aws_vpc" "default" {
     default = true
}

data "aws_subnets" "default" {
     filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
     }
}

resource "aws_instance" "myec2" {
     ami = "ami-00d2efe5bc0683614"
     instance_type = "t2.micro"
     subnet_id = data.aws_subnets.default.ids[0]
     tags = {
         Name = "MyFirstEC2Instance"
     }
}
