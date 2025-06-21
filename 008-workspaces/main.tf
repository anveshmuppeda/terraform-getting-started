module "MyFirstModuleApp" {
  source = "./modules/ec2-app/"
  amiid = var.amiid
  instance_type = var.instance_type
  instance_name = var.instance_name
  securitygroupname = var.securitygroupname
}