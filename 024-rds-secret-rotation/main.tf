module "db_network" {
  source = "./modules/db_network"
  vpc_name = "rds_demo_vpc"
}

locals {
  subnets_list = module.db_network.subnet_ids
  security_group_id = module.db_network.vpc_security_group_ids
  vpc_id = module.db_network.vpc_id
  secretsmanager_id = module.rds_instance.secretsmanager_id
  secretsmanager_arn = module.rds_instance.secretsmanager_arn
}

module "rds_instance" {
  source = "./modules/rds"
  rds_subnet_groups = local.subnets_list
  rds_security_group_ids = [ local.security_group_id ]

  depends_on = [ 
        module.db_network 
    ]
}

module "lambda_rotation" {
  source = "./modules/lambda_rotation"
  rds_subnet_groups = local.subnets_list
  rds_security_group_ids = [ local.security_group_id ]
  secretsmanager_id = local.secretsmanager_id
  secretsmanager_arn = local.secretsmanager_arn
  vpc_id = local.vpc_id
}
