variable "instances" {
  description = "Map of EC2 instances with configuration"
  type = map(object({
    ami                    = string
    instance_type          = string
    subnet_id              = string
    key_name               = string
    volume_size            = number
    volume_type            = string
    termination_protection = bool
    allocate_eip           = optional(bool, false)
    eip_name               = optional(string)  # ✅ Add this
    # optional fields
    user_data              = optional(string)
    iam_instance_profile   = optional(string)
    security_groups        = optional(list(string), [])
    additional_volumes     = optional(list(object({
      device_name = string
      volume_size = number
      volume_type = string
    })), [])
  }))
}

