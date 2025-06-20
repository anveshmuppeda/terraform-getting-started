module "MyFirstModuleApp" {
  source = "./modules/ec2-app/"
  amiid = "ami-09e6f87a47903347c"
  instance_type = "t2.micro"
  instance_name =  "MyFirstInstanceFromModule"
}