terraform {  
  backend "s3" {  
    bucket       = "state-file-shivm"  
    key          = "terraform.tfstate"  
    region       = "us-east-1"  
    encrypt      = true  
    use_lockfile = true  #S3 native locking
    profile      = "aws"
  }  
}