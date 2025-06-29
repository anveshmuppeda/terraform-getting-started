# main.tf

# Security Group for MySQL
resource "aws_security_group" "mysql_sg" {
  name_prefix = "mysql-sg-"
  description = "Security group for MySQL server"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this to your IP for security
  }

  # MySQL port (only if you need external access)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"] # Restrict to your VPC or specific IPs
  }

  # Flask application port
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP (optional, for web applications)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS (optional, for web applications)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysql-security-group"
  }
}

# User data script to install and configure MySQL + Flask App
locals {
  user_data = base64encode(templatefile("${path.module}/install_mysql_flask.sh", {
    mysql_root_password = var.mysql_root_password
    app_db_password     = var.app_db_password
  }))
}

# EC2 Instance
resource "aws_instance" "mysql_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name              = var.key_name
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  user_data             = local.user_data

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  tags = {
    Name        = "MySQL-Flask-Server"
    Environment = "dev"
    Purpose     = "database-app"
  }
}

# Outputs
output "instance_public_ip" {
  description = "Public IP address of the MySQL server"
  value       = aws_instance.mysql_server.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the MySQL server"
  value       = aws_instance.mysql_server.private_ip
}

output "flask_app_url" {
  description = "URL to access the Flask application"
  value       = "http://${aws_instance.mysql_server.public_ip}:5000"
}

output "health_check_url" {
  description = "Health check endpoint"
  value       = "http://${aws_instance.mysql_server.public_ip}:5000/health"
}

output "api_endpoints" {
  description = "Available API endpoints"
  value = {
    health_check = "GET http://${aws_instance.mysql_server.public_ip}:5000/health"
    get_entries  = "GET http://${aws_instance.mysql_server.public_ip}:5000/entries"
    add_entry    = "POST http://${aws_instance.mysql_server.public_ip}:5000/entries"
  }
}

output "ssh_connection_command" {
  description = "SSH command to connect to the server"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.mysql_server.public_ip}"
}