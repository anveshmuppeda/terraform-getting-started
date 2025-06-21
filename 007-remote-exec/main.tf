module "MyFirstModuleApp" {
  source = "./modules/ec2-app/"
  amiid = "ami-09e6f87a47903347c"
  instance_type = "t2.micro"
  instance_name =  "MyFirstInstanceFromModule"
  private_key_path = "~/Desktop/terraform-aws-ec2-keypair.pem" # Path to your private key file
  key_name = "terraform-aws-ec2-keypair" # Name of the key pair to use for SSH access
  # Ensure the private key file has the correct permissions (chmod 400)
  # and is accessible from the machine where Terraform is run.
}