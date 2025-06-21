data "aws_secretsmanager_secret_version" "awssmcreds" {
  secret_id = "terraform-demo-secret"
}

locals {
  secret_data = jsondecode(data.aws_secretsmanager_secret_version.awssmcreds.secret_string)
}

module "MyFirstModuleApp" {
  source = "./modules/ec2-app/"
  amiid = var.amiid
  instance_type = var.instance_type
  instance_name = local.secret_data.username
  securitygroupname = var.securitygroupname
}