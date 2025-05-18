# Global Tagging
variable "global_tags" {
  type = map(string)
  default = {
    ManagedBy   = "Terraform"
    Environment = "Dev"
  }
}

# Provider Variables

variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "aws" # Optional default
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1" # Optional default
}


## VPC variables

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnets" {
  description = "A map of subnet configurations"
  type = map(object({
    cidr = string
    type = string # "public" or "private"
    az   = string # Availability zone
    name = string # Custom name for the subnet
  }))
  default = {
    subnet1  = { cidr = "10.0.1.0/24", type = "public", az = "ap-south-1a", name = "Public_Subnet_1" },
    subnet2  = { cidr = "10.0.2.0/24", type = "public", az = "ap-south-1b", name = "Public_Subnet_2" },
    subnet3  = { cidr = "10.0.3.0/24", type = "public", az = "ap-south-1c", name = "Public_Subnet_3" },
    subnet4  = { cidr = "10.0.4.0/24", type = "public", az = "ap-south-1a", name = "Public_Subnet_4" },
    subnet5  = { cidr = "10.0.5.0/24", type = "public", az = "ap-south-1b", name = "Public_Subnet 5" },
    subnet6  = { cidr = "10.0.6.0/24", type = "private", az = "ap-south-1c", name = "Private_Subnet_1" },
    subnet7  = { cidr = "10.0.7.0/24", type = "private", az = "ap-south-1a", name = "Private_Subnet_2" },
    subnet8  = { cidr = "10.0.8.0/24", type = "private", az = "ap-south-1b", name = "Private_Subnet_3" },
    subnet9  = { cidr = "10.0.9.0/24", type = "private", az = "ap-south-1c", name = "Private_Subnet_4" },
    subnet10 = { cidr = "10.0.10.0/24", type = "private", az = "ap-south-1a", name = "Private_Subnet_5" }
  }
}

## EIP Variable

variable "elastic_ips" {
  description = "Map of EIPs to create with custom names"
  type = map(object({
    name = string
    tags = optional(map(string), {})
  }))
  default = {}
}


## 