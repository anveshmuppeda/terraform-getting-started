module "MyFirstModuleApp" {
  source = "./modules/ec2-app/"
  amiid = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
  instance_name =  "MyFirstInstanceFromModule"
}