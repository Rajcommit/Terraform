output "vpc_id" {
  value = aws_vpc.main.id

   precondition {
    condition     = startswith(aws_vpc.main.id, "vpc-")
    error_message = "VPC ID must start with 'vpc-'. Got: ${aws_vpc.main.id}"
}

}


output "vpc_cidr" {
     value = aws_vpc.main.cidr_block
 }


output "public_subnet_cidrs" {
  value = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  value = aws_subnet.private[*].cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id

  precondition {
  condition     = length(aws_subnet.public[*].id) == 2
  error_message = "Expected 2 public subnets, got ${length(aws_subnet.public[*].id)}"
  }
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id

  precondition {
    condition     = length(aws_subnet.private[*].id) == 2
    error_message = "Expected 2 private subnets, got ${length(aws_subnet.private[*].id)}"
}
}

output "nat_gateway_id" {
  value = var.nat_gateway_enabled ? aws_nat_gateway.main[0].id : null
}

output "internet_gateway_id" {
  value = aws_internet_gateway.maingateway.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}


output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "availability_zone" {
  value = var.availability_zone
}


