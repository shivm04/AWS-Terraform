output "instance_ids" {
  description = "Map of instance names to their AWS instance IDs"
  value       = { for name, inst in aws_instance.ec2 : name => inst.id }
}

output "private_ips" {
  description = "Map of instance names to their private IPs"
  value       = { for name, inst in aws_instance.ec2 : name => inst.private_ip }
}

output "public_ips" {
  description = "Map of instance names to their public IPs (if assigned)"
  value       = { for name, inst in aws_instance.ec2 : name => inst.public_ip }
}

output "availability_zones" {
  description = "Map of instance names to the AZ they are deployed in"
  value       = { for name, inst in aws_instance.ec2 : name => inst.availability_zone }
}

output "ec2_instance_eips" {
  description = "Public IPs of instances with EIPs"
  value = {
    for k, eip in aws_eip.eip : k => eip.public_ip
  }
}

output "ec2_instance_eip_ids" {
  description = "EIP allocation IDs"
  value = {
    for k, eip in aws_eip.eip : k => eip.id
  }
}
