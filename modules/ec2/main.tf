resource "aws_instance" "ec2" {
  for_each = var.instances

  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  subnet_id                   = each.value.subnet_id 
  key_name                    = each.value.key_name
  iam_instance_profile        = try(each.value.iam_instance_profile, null)
  user_data                   = try(each.value.user_data, null)
  disable_api_termination     = each.value.termination_protection
  associate_public_ip_address = null
  vpc_security_group_ids      = try(each.value.security_groups, [])

  root_block_device {
    volume_size = each.value.volume_size
    volume_type = each.value.volume_type
  }
}

locals {
  extra_volumes = {
    for inst_key, inst in var.instances : inst_key => {
      for idx, vol in try(inst.additional_volumes, []) :
      "${inst_key}::${idx}" => merge(vol, { instance_key = inst_key })
    }
  }

  flattened_extra_volumes = merge([for v in values(local.extra_volumes) : v]...)
}



resource "aws_ebs_volume" "extra" {
  for_each = local.flattened_extra_volumes

  availability_zone = aws_instance.ec2[each.value.instance_key].availability_zone
  size              = each.value.volume_size
  type              = each.value.volume_type

  tags = {
    Name = "${each.value.instance_key}-extra-volume-${each.key}"
  }
}


resource "aws_volume_attachment" "extra" {
  for_each = local.flattened_extra_volumes

  device_name = each.value.device_name
  instance_id = aws_instance.ec2[each.value.instance_key].id
  volume_id   = aws_ebs_volume.extra[each.key].id
}


resource "aws_eip" "eip" {
  for_each = {
    for inst_key, inst in var.instances :
    inst_key => inst
    if try(inst.allocate_eip, false)
  }

  instance = aws_instance.ec2[each.key].id
  vpc      = true

  tags = {
    Name = "${each.key}-eip"
  }
}
