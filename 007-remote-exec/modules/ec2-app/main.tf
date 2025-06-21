terraform {
  required_version = ">=1.10"
}

resource "aws_instance" "ec2_example" {

    ami = var.amiid
    instance_type = var.instance_type
    tags = {
        Name = var.instance_name
    }
    vpc_security_group_ids = [aws_security_group.main.id]
    key_name = var.key_name

    user_data = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo mkdir /var/www/html
      sudo chown -R $USER:$USER /var/www/html
      EOF
    
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }

    provisioner "file" {
      source      = "index.html"
      destination = "/var/www/html/index.html"
    }
    
}

resource "aws_security_group" "main" {
  name        = "terraform-example-sg"
  description = "Webserver for EC2 Instances"

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from anywhere
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}