terraform {
  backend "s3" {
    bucket  = "lamatenz-terraform-tfstate"
    key     = "ASG-Build/terraform.tfstate"
    region  = "us-east-1"
    profile = "codebuild-user"
  }
}
