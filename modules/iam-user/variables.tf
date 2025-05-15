variable "name" {
  description = "IAM username"
  type        = string
}

variable "groups" {
  description = "List of IAM groups"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
