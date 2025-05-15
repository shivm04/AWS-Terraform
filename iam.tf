module "shivam_user" {
  source = "./modules/iam-user"
  name   = "shivam"
  tags = {
    CreatedBy = "Terraform"
    Env       = "Dev"
  }
}