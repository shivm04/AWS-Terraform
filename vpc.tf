# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Main VPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main IGW"
  }
}

# Subnets (custom names, CIDR, AZ, type)
resource "aws_subnet" "subnet" {
  for_each = var.subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  # Enable public IP assignment only for public subnets
  map_public_ip_on_launch = each.value.type == "public" ? true : false

  tags = {
    Name = each.value.name
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
}

# Choose one public subnet for NAT Gateway - here we pick the first in the list of public subnets
locals {
  public_subnet_keys = [for key, subnet in var.subnets : key if subnet.type == "public"]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id

  # Use the first public subnet (you can adjust this logic as needed)
  subnet_id = aws_subnet.subnet[local.public_subnet_keys[0]].id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "Main NAT Gateway"
  }
}

# Public Route Table with IGW route + any custom routes if needed
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Associate all public subnets to the public route table
resource "aws_route_table_association" "public" {
  for_each = {
    for key, sn in var.subnets : key => sn if sn.type == "public"
  }

  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.public.id
}

# Private Route Table with NAT Gateway route
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

# Associate all private subnets to the private route table
resource "aws_route_table_association" "private" {
  for_each = {
    for key, sn in var.subnets : key => sn if sn.type == "private"
  }

  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.private.id
}

# Example of adding a custom route to the public route table (adjust as needed)
resource "aws_route" "custom_public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "192.168.0.0/16"
  # For example, if you had a virtual private gateway or another resource, reference its id here.
  # In this example, we’re just showing the syntax. Adjust the target as per your requirements.
  gateway_id = aws_internet_gateway.igw.id
  # Alternatively, if it is a NAT or instance, you could use nat_gateway_id or instance_id.
}

## Custom EIP for the EC2 instances

resource "aws_eip" "custom" {
  for_each = var.elastic_ips
  vpc      = true

  tags = merge(
    {
      Name = each.value.name
    },
    each.value.tags
  )
}
