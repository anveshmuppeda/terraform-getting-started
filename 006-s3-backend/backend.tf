terraform {
  backend "s3" {
    bucket         = "anvesh-terraform-backend-bucket" # Ensure this name is globally unique
    key            = "terraform/terraform.state"
    region         = "us-east-1"
  }
}