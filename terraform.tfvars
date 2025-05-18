# Provider Variables
aws_profile = "aws"
aws_region  = "ap-south-1"

### EIP Configuration

elastic_ips = {
  eip1 = {
    name = "Bastion-EIP"
    tags = {
      Env = "Dev"
    }
  }

  eip2 = {
    name = "NAT-Gateway-EIP"
    tags = {
      Purpose = "NAT"
    }
  }
}


