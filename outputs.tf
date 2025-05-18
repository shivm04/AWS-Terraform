output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "IDs of the subnets created"
  value       = [for s in aws_subnet.subnet : s.id]
}

output "subnet_names" {
  description = "List of subnet names from the 'Name' tag"
  value       = [for s in aws_subnet.subnet : s.tags["Name"]]
}

output "eip_public_ips" {
  description = "Elastic IP public IPs"
  value = {
    for k, eip in aws_eip.custom : k => eip.public_ip
  }
}

output "eip_allocation_ids" {
  description = "Elastic IP allocation IDs"
  value = {
    for k, eip in aws_eip.custom : k => eip.id
  }
}

