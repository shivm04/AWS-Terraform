## TO fetch the subnet IDS for ec2 instances

locals {
  subnet_ids = { for key, subnet in aws_subnet.subnet : key => subnet.id }
}

module "ec2" {
  source = "./modules/ec2"

  instances = {
    "web-server-1" = {
      ami                    = "ami-0af9569868786b23a" ## amazon linux 2023 image
      instance_type          = "t2.micro"
      subnet_id              = local.subnet_ids["subnet1"]
      key_name               = "1831"
      volume_size            = 20
      volume_type            = "gp3"
      termination_protection = true
      #    security_groups        = ["sg-xyz123"]
      #    user_data              = file("scripts/web-init.sh")
      #    iam_instance_profile   = "my-ec2-role"
      additional_volumes = [
        {
          device_name = "/dev/sdf"
          volume_size = 10
          volume_type = "gp2"
        }
      ]
    }
  }
}