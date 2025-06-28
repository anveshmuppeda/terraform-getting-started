resource "aws_vpc" "rds_vpc_demo" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "rds_subnet_demo" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.rds_vpc_demo.id
  cidr_block = cidrsubnet(aws_vpc.rds_vpc_demo.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_internet_gateway" "demo_internet_gateway" {
  vpc_id = aws_vpc.rds_vpc_demo.id

  tags = {
    Name = "rds-demo-igw"
  }
}

data "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.rds_vpc_demo.id
  filter {
    name = "association.main"
    values = ["true"]
  }
}

resource "aws_route" "default_route_igw" {
  route_table_id = data.aws_route_table.main_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.demo_internet_gateway.id
}


resource "aws_security_group" "rds_security_group_demo" {
  name        = var.security_group_name
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.rds_vpc_demo.id

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [aws_vpc.rds_vpc_demo.cidr_block, "0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [aws_vpc.rds_vpc_demo.cidr_block]
    }
  
  tags = {
    Name = var.security_group_name 
  }
}

output "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  value       = aws_subnet.rds_subnet_demo[*].id
}
output "vpc_security_group_ids" {
  description = "List of Security groups"
  value = aws_security_group.rds_security_group_demo.id
}