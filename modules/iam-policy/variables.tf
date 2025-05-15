variable "name" {
  type        = string
  description = "IAM policy name"
}

variable "description" {
  type        = string
  description = "Description of the policy"
}

variable "policy_path" {
  type        = string
  description = "Path to JSON policy file"
}

variable "tags" {
  type        = map(string)
  default     = {}
}
