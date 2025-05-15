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
  default     = "aws"   # Optional default
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"   # Optional default
}
