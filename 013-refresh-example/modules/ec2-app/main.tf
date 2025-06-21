terraform {
  required_version = ">=1.10"
}

resource "aws_instance" "ec2_example" {

    ami = var.amiid
    instance_type = var.instance_type
    tags = {
        Name = var.instance_name
        Env  = "Dev"
    }
    vpc_security_group_ids = [aws_security_group.main.id]

  user_data = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo chown -R $USER:$USER /var/www/html
      sudo echo "<html><body><h1>Hello this is from Simepl App Hosted on AWS EC2 </h1></body></html>" > /var/www/html/index.html
      EOF
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

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
